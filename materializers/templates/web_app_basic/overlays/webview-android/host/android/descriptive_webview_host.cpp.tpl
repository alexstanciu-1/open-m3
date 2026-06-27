#include "scpp/webview.hpp"

#include <jni.h>

namespace {

scpp::shared_p<scpp::ui_app> host_app = scpp::null;
scpp::shared_p<scpp::ui_window> host_window = scpp::null;
scpp::shared_p<scpp::webview> host_view = scpp::null;

void throw_illegal_state(JNIEnv *env, const char *message) {
	if (env == nullptr) {
		return;
	}
	jclass exception_class = env->FindClass("java/lang/IllegalStateException");
	if (exception_class != nullptr) {
		env->ThrowNew(exception_class, message);
		env->DeleteLocalRef(exception_class);
	}
}

scpp::string_t read_jstring(JNIEnv *env, jstring value) {
	if (env == nullptr || value == nullptr) {
		return scpp::string_t("");
	}
	const char *text = env->GetStringUTFChars(value, nullptr);
	if (text == nullptr) {
		return scpp::string_t("");
	}
	scpp::string_t result(text);
	env->ReleaseStringUTFChars(value, text);
	return result;
}

void enqueue_host_event(JNIEnv *env, const char *type, jstring message, jstring url) {
	if (!host_view.has_value().native_value()) {
		return;
	}
	auto queued = scpp::webview_runtime::enqueue_event(
		host_view,
		scpp::string_t(type),
		read_jstring(env, message),
		read_jstring(env, url)
	);
	if (!queued.has_value().native_value()) {
		throw_illegal_state(env, "native event callback failed to queue event");
	}
}

} // namespace

extern "C" JNIEXPORT void JNICALL
{{ android_jni_prefix }}_nativeAttach(JNIEnv *env, jobject activity, jobject webview) {
	if (env == nullptr || activity == nullptr || webview == nullptr) {
		throw_illegal_state(env, "nativeAttach requires Activity and WebView");
		return;
	}

	JavaVM *vm = nullptr;
	if (env->GetJavaVM(&vm) != JNI_OK || vm == nullptr) {
		throw_illegal_state(env, "nativeAttach failed to resolve JavaVM");
		return;
	}

	host_app = scpp::shared<scpp::ui_app>();
	host_window = scpp::shared<scpp::ui_window>();
	host_window->app_handle = host_app;
	auto attached = scpp::webview_runtime::android_attach_activity_webview(host_window, vm, activity, webview);
	if (!attached.has_value().native_value()) {
		host_window = scpp::null;
		host_app = scpp::null;
		throw_illegal_state(env, "nativeAttach failed to attach Activity WebView");
		return;
	}

	auto created = scpp::webview_runtime::create(host_window);
	if (!created.has_value().native_value()) {
		scpp::webview_runtime::android_detach_activity_webview(host_window);
		host_window = scpp::null;
		host_app = scpp::null;
		throw_illegal_state(env, "nativeAttach failed to create WebView handle");
		return;
	}
	host_view = created.value();
}

extern "C" JNIEXPORT void JNICALL
{{ android_jni_prefix }}_nativeLoadApp(JNIEnv *env, jobject, jstring app_path) {
	if (!host_view.has_value().native_value()) {
		throw_illegal_state(env, "nativeLoadApp requires attached WebView");
		return;
	}
	auto loaded = scpp::webview_runtime::load_app(host_view, read_jstring(env, app_path));
	if (!loaded.has_value().native_value()) {
		throw_illegal_state(env, "nativeLoadApp failed");
	}
}

extern "C" JNIEXPORT void JNICALL
{{ android_jni_prefix }}_nativeOnNavigationStarted(JNIEnv *env, jobject, jstring url) {
	enqueue_host_event(env, "webview_navigation_started", nullptr, url);
}

extern "C" JNIEXPORT void JNICALL
{{ android_jni_prefix }}_nativeOnNavigationFinished(JNIEnv *env, jobject, jstring url) {
	enqueue_host_event(env, "webview_navigation_finished", nullptr, url);
}

extern "C" JNIEXPORT void JNICALL
{{ android_jni_prefix }}_nativeOnLoadFailed(JNIEnv *env, jobject, jstring message, jstring url) {
	enqueue_host_event(env, "webview_load_failed", message, url);
}

extern "C" JNIEXPORT void JNICALL
{{ android_jni_prefix }}_nativeOnMessage(JNIEnv *env, jobject, jstring message, jstring url) {
	enqueue_host_event(env, "webview_message", message, url);
}

extern "C" JNIEXPORT void JNICALL
{{ android_jni_prefix }}_nativeDetach(JNIEnv *, jobject) {
	if (host_view.has_value().native_value()) {
		scpp::webview_runtime::close(host_view);
		host_view = scpp::null;
	}
	if (host_window.has_value().native_value()) {
		scpp::webview_runtime::android_detach_activity_webview(host_window);
		host_window = scpp::null;
	}
	host_app = scpp::null;
}
