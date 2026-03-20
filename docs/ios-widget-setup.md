# iOS Widget Setup (Xcode Required)

These steps must be completed on macOS with Xcode installed.

## Steps

1. Open `ios/Runner.xcworkspace` in Xcode

2. **Add Widget Extension target:**
   - File > New > Target > Widget Extension
   - Name it "QRCodeWidget"
   - Uncheck "Include Configuration App Intent" (we use static config)

3. **Replace generated files:**
   - Delete the auto-generated Swift files in the QRCodeWidget group
   - Add the files from `ios/QRCodeWidget/`:
     - `QRCodeWidget.swift`
     - `QRCodeWidgetBundle.swift`
     - `Info.plist`

4. **Add App Group capability:**
   - Select the **Runner** target > Signing & Capabilities > + Capability > App Groups
   - Add group: `group.com.nonprofit.nonprofitapp`
   - Select the **QRCodeWidget** target > Signing & Capabilities > + Capability > App Groups
   - Add the same group: `group.com.nonprofit.nonprofitapp`

5. **Set deployment target:**
   - Select the QRCodeWidget target > General > Minimum Deployments
   - Set to iOS 16.0

6. **Update Podfile** (`ios/Podfile`):
   Add the widget extension target:
   ```ruby
   target 'QRCodeWidgetExtension' do
     use_frameworks!
   end
   ```

7. Run `pod install` from the `ios/` directory

8. Build and run on a device or simulator to test
