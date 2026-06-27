#include "scpp/ui.hpp"
#include "scpp/webview.hpp"

#import <UIKit/UIKit.h>

#include <cstdlib>
#include <iostream>
#include <string>

@interface DescriptiveWebViewAppDelegate : UIResponder<UIApplicationDelegate>
@property (nonatomic, strong) UIWindow *systemWindow;
@end

@implementation DescriptiveWebViewAppDelegate {
	scpp::shared_p<scpp::ui::app> _app;
	scpp::shared_p<scpp::ui::window> _window;
	scpp::shared_p<scpp::webview> _view;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
	(void)application;
	(void)launchOptions;

	auto appResult = scpp::ui::app_create();
	if (!appResult.has_value().native_value()) {
		std::cerr << appResult.error()->get_message().native_value() << "\n";
		std::exit(1);
	}
	_app = appResult.value();

	CGRect bounds = UIScreen.mainScreen.bounds;
	auto windowResult = scpp::ui::window_create(
		_app,
		scpp::string_t("{{ app_title }}"),
		scpp::int_t(static_cast<int>(bounds.size.width)),
		scpp::int_t(static_cast<int>(bounds.size.height))
	);
	if (!windowResult.has_value().native_value()) {
		std::cerr << windowResult.error()->get_message().native_value() << "\n";
		std::exit(1);
	}
	_window = windowResult.value();
	self.systemWindow = static_cast<UIWindow *>(_window->native_handle);

	auto showResult = scpp::ui::window_show(_window);
	if (!showResult.has_value().native_value()) {
		std::cerr << showResult.error()->get_message().native_value() << "\n";
		std::exit(1);
	}

	auto viewResult = scpp::webview_runtime::create(_window);
	if (!viewResult.has_value().native_value()) {
		std::cerr << viewResult.error()->get_message().native_value() << "\n";
		std::exit(1);
	}
	_view = viewResult.value();

	NSString *resourcePath = NSBundle.mainBundle.resourcePath;
	NSString *appPath = [resourcePath stringByAppendingPathComponent:@"app"];
	auto loadResult = scpp::webview_runtime::load_app(_view, scpp::string_t([appPath UTF8String]));
	if (!loadResult.has_value().native_value()) {
		std::cerr << loadResult.error()->get_message().native_value() << "\n";
		std::exit(1);
	}

	[NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(pollEvents:) userInfo:nil repeats:YES];
	return YES;
}

- (void)pollEvents:(NSTimer *)timer
{
	(void)timer;
	if (!_app.has_value().native_value()) {
		return;
	}
	(void)scpp::ui::app_poll(_app);
	while (!_app->pending_events.empty()) {
		_app->pending_events.pop_front();
	}
}

@end

int main(int argc, char *argv[]) {
	@autoreleasepool {
		return UIApplicationMain(argc, argv, nil, NSStringFromClass([DescriptiveWebViewAppDelegate class]));
	}
}
