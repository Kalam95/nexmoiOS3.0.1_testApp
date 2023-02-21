# nexmoiOS3.0.1_testApp

This is the iOS NexmoClient Test App used for testing Compatibility with the SDK version 3.0.1.

## Setup

### Prerequisites

- Vonage CLI
- Vonage developer account
  - Voange application
- NCCO server
- Xcode 13
- Apple developer Account for Push certificate (optional for push)

#### Setup Vonage Cli

1. Install `vonage` cli

    `npm install --location=global @Vonage/cli`

2. Make a Vonage APP (if needed)

    ```sh
    vonage apps:create APP_NAME --voice_answer_url=LINK_TO_NCCO --voice_event_url=example.com 
    ```

3. Make A Vonage Admin token (Vonage JWT without sub)

    ```sh
    vonage jwt --key_file=./vonage.private.key --acl='{"paths":{"/*/users/**":{},"/*/conversations/**":{},"/*/sessions/**":{},"/*/devices/**":{},"/*/image/**":{},"/*/media/**":{},"/*/applications/**":{},"/*/push/**":{},"/*/knocking/**":{},"/*/legs/**":{}}}' --app_id=VONAGE_APP_ID
    ```
4. Once you got the token, you need to add the token to the **Client manager** at line number 24

## Run Locally

Clone the project

```bash
  git clone https://github.com/Kalam95/nexmoiOS3.0.1_testApp.git
```

Go to the project directory

```bash
  cd /NexmoTest3.0.1
```

Pod install

```bash
  sudo gem install cocoapods
```

```bash
    pod install
```

or 

```bash
   arch -x86_64 pod install
```

Open in xcode(NexmoTest3.0.1.xcworkspace)

### If you want to test push notification then follow this [link](https://developer.vonage.com/en/client-sdk/setup/set-up-push-notifications/ios#integrate-voip-push-notifications-in-your-application) till **Using the Terminal**
