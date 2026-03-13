# Testing Favorites Persistence - Step by Step

## What Should Happen
When you mark apps as favorites and save, those apps should:
1. Appear in a "★ Favorites" section at the TOP of your portal
2. **Remain there even when you close and reopen the portal**
3. Stay visible even if you filter by category or use search

## Test Steps

### Part 1: Mark an App as Favorite
1. **Open the Portal** (run PortalBuilder.ps1 to build and launch)
2. **Click Settings (⚙)** button in top-right
3. **Select an app** from the list (e.g., "Console")
4. You should see dynamic help text: "👇 'Console' is not a favorite - Click to add"
5. **Click the big gold button** "★ Toggle Favorite for Selected App"
6. Confirmation message: "'Console' added to favorites! It will appear at the top of your portal."
7. The app's row now shows **"★ YES"** and has yellow background
8. Select another app and mark it as favorite (repeat steps 4-8)
9. Click **"Save Changes"** button at the bottom

### Part 2: Verify Favorites Appear at Top
1. The portal should refresh automatically
2. Look at the portal window - you should see a **"★ Favorites"** section at the top
3. Your favorited apps should be displayed in this section
4. All other apps are below in their category sections

### Part 3: Verify Persistence (This is THE TEST)
1. **Close the entire portal window** (click X button)
2. **Reopen the portal** (click portal shortcut or run portal.ps1 again)
3. **Expected:** Your favorites still appear at the top in the "★ Favorites" section
4. **What should NOT happen:** Favorites should NOT disappear

### Part 4: Verify Favorites Persist After Filtering
1. Use the **Category** dropdown - select a specific category (NOT "All Categories")
2. **Expected:** Favorites still visible at top, even for other categories
3. Use the **Search** box - search for something
4. **Expected:** Favorites still visible at top

## Debugging (If Favorites Don't Appear)

If favorites disappear after restart, check the PowerShell console output for lines like:
```
DEBUG: Current Favorites count: 2
DEBUG: Favorite items: Console, Notepad
DEBUG: Normalized favorites: Console, Notepad
DEBUG: Favorites found: 2
DEBUG: Favorite app names: Console, Notepad
```

If you see "Favorites found: 0" when it should be 2, that means:
- The names don't match between what was saved and what's loaded
- Usually a whitespace issue

## What Files Store Favorites

Preferences are saved in:
```
%APPDATA%\ApplicationPortal\preferences.json
```

You can look at this file to see what favorites are stored:
```json
{
  "HiddenApps": [],
  "Favorites": ["Console", "Notepad"]
}
```

If this file has your favorite apps listed, but they don't appear in the portal, it's a **matching issue**.

## Common Issues & Solutions

### Issue: Favorites show in Settings but disappear in portal
**Cause:** Name mismatch (spaces, case sensitivity)
**Solution:** Check preferences.json file to see exact names

### Issue: Only 1 favorite is saved when you added 2
**Cause:** Array serialization issue when saving single item to JSON
**Solution:** Fixed - should work now with improved Save-UserPreferences function

### Issue: Favorites are saved but don't display at startup
**Cause:** Temporary - reload preferences not loading as array
**Solution:** Fixed - improved loading logic with array type checking

## Testing Confirmation

✅ **PASS** = Favorite apps appear at top, persist after close/reopen, stay visible during filtering
❌ **FAIL** = Favorites disappear, or only show sometimes, or require specific category selection

