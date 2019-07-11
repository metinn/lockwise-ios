/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

import Foundation
import Quick
import Nimble
import RxSwift

@testable import Lockbox

class RouteActionSpec: QuickSpec {
    class FakeDispatcher: Dispatcher {
        var actionTypeArgument: Action?

        override func dispatch(action: Action) {
            self.actionTypeArgument = action
        }
    }

    private var dispatcher: FakeDispatcher!

    override func spec() {

        describe("MainRouteAction") {
            describe("equality") {
                it("listing is always equal") {
                    expect(MainRouteAction.list).to(equal(MainRouteAction.list))
                }

                it("detail view action is equal when the itemId is the same") {
                    let itemId = "fdjkfdsj"
                    expect(MainRouteAction.detail(itemId: itemId)).to(equal(MainRouteAction.detail(itemId: itemId)))
                }

                it("detail view action is not equal when the itemId is different") {
                    expect(MainRouteAction.detail(itemId: "dfsljkfsd"))
                            .notTo(equal(MainRouteAction.detail(itemId: "fsdsdf")))
                }

                it("detail action and list action are never equal") {
                    expect(MainRouteAction.detail(itemId: "sfddfs")).notTo(equal(MainRouteAction.list))
                }
            }

            describe("telemetry") {
                it("returns the type of view as event object") {
                    expect(MainRouteAction.list.eventObject).to(equal(TelemetryEventObject.entryList))
                    expect(MainRouteAction.detail(itemId: "sfddfs").eventObject).to(equal(TelemetryEventObject.entryDetail))
                }

                it("returns show as event method") {
                    expect(MainRouteAction.list.eventMethod).to(equal(TelemetryEventMethod.show))
                }

                it("returns nil as the value") {
                    expect(MainRouteAction.list.value).to(beNil())
                    expect(MainRouteAction.detail(itemId: "fsdsdfd").value).to(beNil())
                }

                it("returns nil for the list extra and the itemID for the detail extra") {
                    let itemID = "aadsadsdas"
                    expect(MainRouteAction.list.extras).to(beNil())
                    let extraValue = MainRouteAction.detail(itemId: itemID).extras?[ExtraKey.itemid.rawValue] as? String
                    expect(extraValue).to(equal(itemID))
                }
            }
        }

        describe("SettingRouteAction") {
            describe("telemetry") {
                it("event method is equal to show") {
                    expect(SettingRouteAction.list.eventMethod).to(equal(TelemetryEventMethod.show))
                }

                it("event object is equal to the setting view shown") {
                    expect(SettingRouteAction.list.eventObject).to(equal(TelemetryEventObject.settingsList))
                    expect(SettingRouteAction.account.eventObject).to(equal(TelemetryEventObject.settingsAccount))
                    expect(SettingRouteAction.autoLock.eventObject).to(equal(TelemetryEventObject.settingsAutolock))
                    expect(SettingRouteAction.preferredBrowser.eventObject).to(equal(TelemetryEventObject.settingsPreferredBrowser))
                    expect(SettingRouteAction.autofillInstructions.eventObject).to(equal(TelemetryEventObject.autofillSettingsInstructions))
                }

                it("returns nil as the value") {
                    expect(SettingRouteAction.list.value).to(beNil())
                    expect(SettingRouteAction.account.value).to(beNil())
                    expect(SettingRouteAction.autoLock.value).to(beNil())
                    expect(SettingRouteAction.preferredBrowser.value).to(beNil())
                }

                it("returns nil as for the extras") {
                    expect(SettingRouteAction.list.extras).to(beNil())
                    expect(SettingRouteAction.account.extras).to(beNil())
                    expect(SettingRouteAction.autoLock.extras).to(beNil())
                    expect(SettingRouteAction.preferredBrowser.extras).to(beNil())
                }
            }
        }

        describe("LoginRouteAction") {
            describe("telemetry") {
                it("event method is equal to show") {
                    expect(SettingRouteAction.list.eventMethod).to(equal(TelemetryEventMethod.show))
                }

                it("event object is equal to the login view shown") {
                    expect(LoginRouteAction.welcome.eventObject).to(equal(TelemetryEventObject.loginWelcome))
                    expect(LoginRouteAction.fxa.eventObject).to(equal(TelemetryEventObject.loginFxa))
                    expect(LoginRouteAction.onboardingConfirmation.eventObject).to(equal(TelemetryEventObject.loginOnboardingConfirmation))
                    expect(LoginRouteAction.autofillOnboarding.eventObject).to(equal(TelemetryEventObject.autofillOnboarding))
                    expect(LoginRouteAction.autofillInstructions.eventObject).to(equal(TelemetryEventObject.autofillOnboardingInstructions))
                }

                it("returns nil as the value") {
                    expect(LoginRouteAction.welcome.value).to(beNil())
                    expect(LoginRouteAction.fxa.value).to(beNil())
                    expect(LoginRouteAction.autofillOnboarding.value).to(beNil())
                    expect(LoginRouteAction.autofillInstructions.value).to(beNil())
                }

                it("returns nil as for the extras") {
                  expect(LoginRouteAction.welcome.extras).to(beNil())
                  expect(LoginRouteAction.fxa.extras).to(beNil())
                  expect(LoginRouteAction.autofillOnboarding.extras).to(beNil())
                  expect(LoginRouteAction.autofillInstructions.extras).to(beNil())
                }
            }
        }

        describe("ExternalWebsiteRouteAction") {
            describe("equality") {
                it("actions are equal when the title and URL string are equal") {
                    expect(ExternalWebsiteRouteAction(urlString: "www.example.com", title: "blah", returnRoute: MainRouteAction.list))
                            .to(equal(ExternalWebsiteRouteAction(urlString: "www.example.com", title: "blah", returnRoute: MainRouteAction.list)))
                    expect(ExternalWebsiteRouteAction(urlString: "www.example.com", title: "blah", returnRoute: MainRouteAction.list))
                            .to(equal(ExternalWebsiteRouteAction(urlString: "www.example.com", title: "blah", returnRoute: SettingRouteAction.list)))
                    expect(ExternalWebsiteRouteAction(urlString: "www.example.com", title: "blah", returnRoute: MainRouteAction.list))
                            .notTo(equal(ExternalWebsiteRouteAction(urlString: "www.meow.com", title: "blah", returnRoute: SettingRouteAction.list)))
                    expect(ExternalWebsiteRouteAction(urlString: "www.example.com", title: "woof", returnRoute: MainRouteAction.list))
                            .notTo(equal(ExternalWebsiteRouteAction(urlString: "www.example.com", title: "blah", returnRoute: SettingRouteAction.list)))
                    expect(ExternalWebsiteRouteAction(urlString: "www.example.com", title: "woof", returnRoute: MainRouteAction.list))
                            .notTo(equal(ExternalWebsiteRouteAction(urlString: "www.meow.com", title: "blah", returnRoute: SettingRouteAction.list)))
                }
            }

            describe("telemetry") {
                it("event method equals show") {
                    expect(ExternalWebsiteRouteAction(urlString: Constant.app.faqURLtop, title: "FAQ", returnRoute: SettingRouteAction.list).eventMethod).to(equal(TelemetryEventMethod.show))
                }

                it("event object matches") {
                    expect(ExternalWebsiteRouteAction(urlString: Constant.app.faqURLtop, title: "FAQ", returnRoute: SettingRouteAction.list).eventObject).to(equal(TelemetryEventObject.settingsFaq))
                    expect(ExternalWebsiteRouteAction(urlString: Constant.app.getSupportURL, title: "Support", returnRoute: SettingRouteAction.list).eventObject).to(equal(TelemetryEventObject.settingsGetSupport))
                    expect(ExternalWebsiteRouteAction(urlString: Constant.app.provideFeedbackURL, title: "Provide Feedback", returnRoute: SettingRouteAction.list).eventObject).to(equal(TelemetryEventObject.settingsProvideFeedback))
                    expect(ExternalWebsiteRouteAction(urlString: Constant.app.privacyURL, title: "Privacy", returnRoute: SettingRouteAction.list).eventObject).to(equal(TelemetryEventObject.settingsPrivacy))
                    expect(ExternalWebsiteRouteAction(urlString: Constant.app.securityFAQ, title: "Security", returnRoute: SettingRouteAction.list).eventObject).to(equal(TelemetryEventObject.onboardingConfirmationPrivacy))
                    expect(ExternalWebsiteRouteAction(urlString: "http://www.mozilla.com", title: "Mozilla", returnRoute: SettingRouteAction.list).eventObject).to(equal(TelemetryEventObject.externalWebsite))
                }
            }
        }

        describe("OnboardingStatusAction") {
            describe("equality") {
                it("actions are equal when onboardingInProgress is equal") {
                    expect(OnboardingStatusAction(onboardingInProgress: true)).to(equal(OnboardingStatusAction(onboardingInProgress: true)))
                    expect(OnboardingStatusAction(onboardingInProgress: false)).notTo(equal(OnboardingStatusAction(onboardingInProgress: true)))
                }
            }
        }
    }
}
