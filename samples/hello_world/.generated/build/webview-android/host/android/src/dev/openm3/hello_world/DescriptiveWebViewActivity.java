package dev.openm3.hello_world;

import android.app.Activity;
import android.os.Bundle;
import android.webkit.JavascriptInterface;
import android.webkit.WebResourceError;
import android.webkit.WebResourceRequest;
import android.webkit.WebSettings;
import android.webkit.WebView;
import android.webkit.WebViewClient;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;

public final class DescriptiveWebViewActivity extends Activity {
	private WebView webView;

	static {
		System.loadLibrary("descriptive_webview_host");
	}

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);

		webView = new WebView(this);
		WebSettings settings = webView.getSettings();
		settings.setJavaScriptEnabled(true);
		settings.setDomStorageEnabled(true);
		settings.setAllowFileAccess(true);
		settings.setAllowFileAccessFromFileURLs(true);
		settings.setAllowUniversalAccessFromFileURLs(true);
		webView.setWebViewClient(new HostWebViewClient());
		webView.addJavascriptInterface(new HostJavascriptBridge(), "simplecpp");
		webView.addJavascriptInterface(new HostJavascriptBridge(), "SimpleCpp");
		setContentView(webView);

		try {
			File appDir = new File(getFilesDir(), "app");
			copyAssetTree("app", appDir);
			nativeAttach(webView);
			nativeLoadApp(appDir.getAbsolutePath());
		} catch (IOException error) {
			throw new IllegalStateException("Failed to prepare generated app assets", error);
		}
	}

	@Override
	protected void onDestroy() {
		nativeDetach();
		webView = null;
		super.onDestroy();
	}

	private native void nativeAttach(WebView view);
	private native void nativeLoadApp(String appPath);
	private native void nativeOnNavigationStarted(String url);
	private native void nativeOnNavigationFinished(String url);
	private native void nativeOnLoadFailed(String message, String url);
	private native void nativeOnMessage(String message, String url);
	private native void nativeDetach();

	private void copyAssetTree(String assetPath, File target) throws IOException {
		String[] children = getAssets().list(assetPath);
		if (children == null || children.length == 0) {
			copyAssetFile(assetPath, target);
			return;
		}
		if (!target.exists() && !target.mkdirs()) {
			throw new IOException("Failed to create directory: " + target);
		}
		for (String child : children) {
			copyAssetTree(assetPath + "/" + child, new File(target, child));
		}
	}

	private void copyAssetFile(String assetPath, File target) throws IOException {
		File parent = target.getParentFile();
		if (parent != null && !parent.exists() && !parent.mkdirs()) {
			throw new IOException("Failed to create directory: " + parent);
		}
		try (InputStream input = getAssets().open(assetPath); FileOutputStream output = new FileOutputStream(target)) {
			byte[] buffer = new byte[16384];
			int read;
			while ((read = input.read(buffer)) != -1) {
				output.write(buffer, 0, read);
			}
		}
	}

	private final class HostWebViewClient extends WebViewClient {
		@Override
		public void onPageStarted(WebView view, String url, android.graphics.Bitmap favicon) {
			nativeOnNavigationStarted(url == null ? "" : url);
		}

		@Override
		public void onPageFinished(WebView view, String url) {
			nativeOnNavigationFinished(url == null ? "" : url);
		}

		@Override
		public void onReceivedError(WebView view, WebResourceRequest request, WebResourceError error) {
			String url = request == null || request.getUrl() == null ? "" : request.getUrl().toString();
			String message = error == null || error.getDescription() == null ? "" : error.getDescription().toString();
			nativeOnLoadFailed(message, url);
		}
	}

	private final class HostJavascriptBridge {
		@JavascriptInterface
		public void postMessage(final String message) {
			runOnUiThread(new Runnable() {
				@Override
				public void run() {
					nativeOnMessage(message == null ? "" : message, webView == null || webView.getUrl() == null ? "" : webView.getUrl());
				}
			});
		}
	}
}
