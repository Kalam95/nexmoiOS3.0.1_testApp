//
//  SceneDelegate.swift
//  NexmoTest3.0.1
//
//  Created by Mehboob Alam on 10.02.23.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let _ = (scene as? UIWindowScene) else { return }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}

/**

{
  "application_id": "4fed3d7a-3f65-436d-87dd-7751394aa433",
  "user_id": "USR-fde4c91f-59a8-4a67-b326-1e21f0cffaa1",
  "name": "alam",
  "channels": {},
  "devices": {
    "2FFF6CC7-18FC-4423-ADD0-3E20DC9FE965": {
      "device_id": "2FFF6CC7-18FC-4423-ADD0-3E20DC9FE965",
      "device_push_ttl": 10,
      "device_type": "ios",
      "tokens": {
        "voip": {
          "token": "01555ee5689d28f065eb80e4cf604d88b06b1cafcb2f3836b3eb3c84e0a2a31c",
          "bundle_id": "com.nexmo.nexmoclient-push-notifications-test-app-ios.voip"
        }
      }
    },
    "DD493374-9AEF-4FDD-A7F5-E131C5548CE2": {
      "device_id": "DD493374-9AEF-4FDD-A7F5-E131C5548CE2",
      "device_push_ttl": 10,
      "device_type": "ios",
      "tokens": {
        "voip": {
          "token": "01555ee5689d28f065eb80e4cf604d88b06b1cafcb2f3836b3eb3c84e0a2a31c",
          "bundle_id": "com.nexmo.nexmoclient-push-notifications-test-app-ios.voip"
        }
      }
    },
    "F7E33E7A-45E8-498C-8A6A-DEF90BC82940": {
      "device_id": "F7E33E7A-45E8-498C-8A6A-DEF90BC82940",
      "device_push_ttl": 10,
      "device_type": "ios",
      "tokens": {
        "push": {
          "token": "941b0416a02c79301e6b73ecb0cb395db7839f644d86992fc6e4f80de7fadfa1",
          "bundle_id": "com.nexmo.nexmoclient-push-notifications-test-app-ios"
        },
        "voip": {
          "token": "01555ee5689d28f065eb80e4cf604d88b06b1cafcb2f3836b3eb3c84e0a2a31c",
          "bundle_id": "com.nexmo.nexmoclient-push-notifications-test-app-ios.voip"
        }
      },
      "device_push_environment": "sandbox"
    },
    "5E40B9DE-883A-4DE8-90E5-F60F6B7C680E": {
      "device_id": "5E40B9DE-883A-4DE8-90E5-F60F6B7C680E",
      "device_push_ttl": 10,
      "device_type": "ios",
      "tokens": {
        "push": {
          "token": "8bf20b94973814053a3f9e7e4743c855cd9dc92d51cd401d1bb78f21e430d2d0",
          "bundle_id": "com.nexmo.nexmoclient-push-notifications-test-app-ios"
        },
        "voip": {
          "token": "01555ee5689d28f065eb80e4cf604d88b06b1cafcb2f3836b3eb3c84e0a2a31c",
          "bundle_id": "com.nexmo.nexmoclient-push-notifications-test-app-ios.voip"
        }
      },
      "device_push_environment": "sandbox"
    },
    "BDB712DA-8927-43B1-8D09-36BDCD5EC840": {
      "device_id": "BDB712DA-8927-43B1-8D09-36BDCD5EC840",
      "device_push_ttl": 10,
      "device_type": "ios",
      "tokens": {
        "push": {
          "token": "45a70e9fb215a180d1bf6ebe1c6d9e11be6d19b0360a088f3af802f809c693c6",
          "bundle_id": "com.nexmo.nexmoclient-push-notifications-test-app-ios"
        },
        "voip": {
          "token": "01555ee5689d28f065eb80e4cf604d88b06b1cafcb2f3836b3eb3c84e0a2a31c",
          "bundle_id": "com.nexmo.nexmoclient-push-notifications-test-app-ios.voip"
        }
      },
      "device_push_environment": "sandbox"
    },
    "35EFDBE4-512A-4949-BC20-95E443444C06": {
      "device_id": "35EFDBE4-512A-4949-BC20-95E443444C06",
      "device_push_ttl": 10,
      "device_type": "ios",
      "tokens": {
        "push": {
          "token": "bfa273322e9f000979c37537f14068a8fd89270c1951fbefe1ec70a9038f84c0",
          "bundle_id": "com.nexmo.nexmoclient-push-notifications-test-app-ios"
        },
        "voip": {
          "token": "01555ee5689d28f065eb80e4cf604d88b06b1cafcb2f3836b3eb3c84e0a2a31c",
          "bundle_id": "com.nexmo.nexmoclient-push-notifications-test-app-ios.voip"
        }
      },
      "device_push_environment": "sandbox"
    },
    "CC2DFBCF-0A61-4E14-973E-282B626B2844": {
      "device_id": "CC2DFBCF-0A61-4E14-973E-282B626B2844",
      "device_push_ttl": 10,
      "device_type": "ios",
      "tokens": {
        "push": {
          "token": "93c062ea121ea681f28e0edd364b47f919fc0e24afd6b2531c7c634129845810",
          "bundle_id": "com.nexmo.nexmoclient-push-notifications-test-app-ios"
        },
        "voip": {
          "token": "01555ee5689d28f065eb80e4cf604d88b06b1cafcb2f3836b3eb3c84e0a2a31c",
          "bundle_id": "com.nexmo.nexmoclient-push-notifications-test-app-ios.voip"
        }
      },
      "device_push_environment": "sandbox"
    },
    "0C3DC455-4FAE-4A1C-93A5-B19010965F65": {
      "device_id": "0C3DC455-4FAE-4A1C-93A5-B19010965F65",
      "device_push_ttl": 10,
      "device_type": "ios",
      "tokens": {
        "push": {
          "token": "14f4ded1437329c062ba36b5738e4a2e9361c881408282768ceeab2c4b2dc02d",
          "bundle_id": "com.nexmo.nexmoclient-push-notifications-test-app-ios"
        },
        "voip": {
          "token": "01555ee5689d28f065eb80e4cf604d88b06b1cafcb2f3836b3eb3c84e0a2a31c",
          "bundle_id": "com.nexmo.nexmoclient-push-notifications-test-app-ios.voip"
        }
      },
      "device_push_environment": "sandbox"
    },
    "D7F1145D-8365-4305-8BD7-B2F59158592D": {
      "device_id": "D7F1145D-8365-4305-8BD7-B2F59158592D",
      "device_push_ttl": 10,
      "device_type": "ios",
      "tokens": {
        "push": {
          "token": "804c2861caef647c96f6c92ef07872f4ed8fd5e432e029d8d1d7362922cb345cdeefa103e4f75f87523cac5e26a11adc44c8dc605057e32590969a7ab6ea7706464957b027d207274b7dc50344962339",
          "bundle_id": "com.nexmo.nexmoclient-push-notifications-test-app-ios"
        },
        "voip": {
          "token": "800f4f72ecf7a00bb177a1c0f6490f44881346fe51c7ce332364108562f4e364047e8627692adea04cfb6f79949e1ad941197e494a8a1f1284677974bfd563a81632e36751d2ce5f1e22201c9b63337b",
          "bundle_id": "com.nexmo.nexmoclient-push-notifications-test-app-ios.voip"
        }
      },
      "device_push_environment": "sandbox"
    },
    "53eb68fe-68a9-49bd-b116-866f38e56f17": {
      "device_id": "53eb68fe-68a9-49bd-b116-866f38e56f17",
      "device_push_ttl": 0,
      "device_type": "android",
      "tokens": {
        "push": {
          "token": "cp1O4WhCTQ-bbUlxA3yOGn:APA91bHfa6KKUh6xo_jifyrYP4QO_T5cN4-K_iHQqj3Kjw8B7NdZj1-ZxCCnAiZS2Tzta-0EuhJZxdawtmWHOu9S6fCBhJWuXLmC2XgMwzFc26GveffepbsDPVj9ZV5NuKlltXxEE5ZW"
        }
      }
    },
    "5b9dcc76-ed87-4112-bc15-52a1df45c54c": {
      "device_id": "5b9dcc76-ed87-4112-bc15-52a1df45c54c",
      "device_push_ttl": 0,
      "device_type": "android",
      "tokens": {
        "push": {
          "token": "fujuurocQFqxjGTo_j_W2Q:APA91bGzk_hL50X_hLUqo46uMRGFYMI7eKM6zyC0bFavNEiMzV0uqaxgVr5I14dprHVOa7ZOkelSCgdSFrvBijObI2pYwPtC-DO4hj2vuB2PGq901C60DSySUVMz-Y6gRcRz7cSFIZoe"
        }
      }
    },
    "DB193FE9-329D-44F5-9869-14F0D1244597": {
      "device_id": "DB193FE9-329D-44F5-9869-14F0D1244597",
      "device_push_ttl": 10,
      "device_type": "ios",
      "tokens": {
        "push": {
          "token": "801ee76621c6e1cfd30e7ad2f8798e6111c70ce95ef3193d2948874eaf31396adae3910432795204fb55886b5e2c86c024e4688928c6c44f694b9e5889fcfd037cfd9a23fa6d7677d1be2d1f265bdebb",
          "bundle_id": "com.nexmo.nexmoclient-push-notifications-test-app-ios"
        },
        "voip": {
          "token": "801b7aa38e83b722c6c8f672d1842c3fbeb475f215748f5fbaeda6193f408206bd3a081da9962de3a42b96201969965062d828aa4bc8c389d6a50e1e42c3c0c634ccac440a16ebdc0910d255cfba43f9",
          "bundle_id": "com.nexmo.nexmoclient-push-notifications-test-app-ios.voip"
        }
      },
      "device_push_environment": "sandbox"
    },
    "A54B41F0-DB68-4E68-A932-C5AA19C62331": {
      "device_id": "A54B41F0-DB68-4E68-A932-C5AA19C62331",
      "device_push_ttl": 10,
      "device_type": "ios",
      "tokens": {
        "push": {
          "token": "c18788c61891e9a8a50d4466981138b8f8fed056c5c75b8f77537d01db5df1a1",
          "bundle_id": "com.nexmo.nexmoclient-push-notifications-test-app-ios"
        },
        "voip": {
          "token": "01555ee5689d28f065eb80e4cf604d88b06b1cafcb2f3836b3eb3c84e0a2a31c",
          "bundle_id": "com.nexmo.nexmoclient-push-notifications-test-app-ios.voip"
        }
      },
      "device_push_environment": "sandbox"
    },
    "EFFE7C28-09D9-4828-B7DA-C372B5C45C9A": {
      "device_id": "EFFE7C28-09D9-4828-B7DA-C372B5C45C9A",
      "device_push_ttl": null,
      "device_type": "ios",
      "tokens": {
        "voip": {
          "token": "17d6d48de04d8b6661931b02502099fda5a7caf336c3161c7da9edd0df73b4f9",
          "bundle_id": "Vonage.NexmoTest3-0-1.voip"
        }
      },
      "device_push_environment": "sandbox"
    },
    "EFC8F339-5A95-41A6-B6D6-36308C9CC5E2": {
      "device_id": "EFC8F339-5A95-41A6-B6D6-36308C9CC5E2",
      "device_push_ttl": null,
      "device_type": "ios",
      "tokens": {
        "voip": {
          "token": "17d6d48de04d8b6661931b02502099fda5a7caf336c3161c7da9edd0df73b4f9",
          "bundle_id": "Vonage.NexmoTest3-0-1.voip"
        }
      },
      "device_push_environment": "sandbox"
    },
    "191BE620-7247-42A5-904C-41E7B31FAEE1": {
      "device_id": "191BE620-7247-42A5-904C-41E7B31FAEE1",
      "device_push_ttl": null,
      "device_type": "ios",
      "tokens": {
        "voip": {
          "token": "17d6d48de04d8b6661931b02502099fda5a7caf336c3161c7da9edd0df73b4f9",
          "bundle_id": "Vonage.NexmoTest3-0-1.voip"
        },
        "push": {
          "token": "0905a483a7396af21f873c4d5c3b26b00b65cba24d9d7e6b33708f07f75f19e9",
          "bundle_id": "Vonage.NexmoTest3-0-1"
        }
      },
      "device_push_environment": "sandbox"
    }
  },
  "timestamp": {
    "created": "2022-07-06T15:17:32.871Z"
  },
  "properties": {
    "custom_data": {}
  },
  "type": "user"
}
*/

//extension Notification.Name {
//    static var incomingCallViaPush: String
//}
