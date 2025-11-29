# C Drive Cleanup Plan - Flutter/Android Build Artifacts

## 📊 Current Situation

### Files Found on C Drive:
1. **`C:\Users\Asmit\.gradle`** - 0.9 GB (36,047 files)
   - Gradle cache and build artifacts
   - **Status**: ✅ Safe to delete (D:\gradle_home has 5.08 GB - more complete cache)

2. **`C:\Users\Asmit\.android`** - 4.4 GB (92 files)
   - Contains Android emulator AVDs (Android Virtual Devices)
   - Contains: `Medium_Phone_API_35.avd`, `Pixel_4_-_Fortura_Test.avd`
   - **Status**: ⚠️ Contains emulator configurations
   - **Note**: If emulators are working from D drive, this can be deleted

### Total Space to Recover: **5.31 GB**

---

## 🎯 Cleanup Plan

### Phase 1: Safe Deletions (Recommended)
**These can be safely deleted since D drive has equivalents:**

1. **Delete Gradle Cache on C Drive**
   - **Target**: `C:\Users\Asmit\.gradle`
   - **Reason**: D:\gradle_home already contains a more complete Gradle cache (5.08 GB vs 0.9 GB)
   - **Space Recovered**: ~0.9 GB
   - **Risk**: Low (D drive has the cache)

### Phase 2: Conditional Deletions (Requires Confirmation)
**These contain emulator data - verify D drive has them first:**

2. **Delete Android Cache on C Drive**
   - **Target**: `C:\Users\Asmit\.android`
   - **Contains**: Emulator AVDs (Medium_Phone_API_35, Pixel_4_-_Fortura_Test)
   - **Space Recovered**: ~4.4 GB
   - **Risk**: Medium (if emulators are only configured on C drive, they'll need to be recreated)
   - **Action Required**: Verify emulators work from D drive before deletion

### Phase 3: Temporary Files Cleanup (Optional)
**These are temporary build files:**

3. **Clean Flutter/Gradle Temp Files**
   - **Target**: `C:\Users\Asmit\AppData\Local\Temp\*flutter*` and `*gradle*`
   - **Space Recovered**: Variable (usually small)
   - **Risk**: Low (temp files are regenerated)

---

## ⚠️ Important Notes

1. **Before Deletion**:
   - Ensure emulator is NOT running
   - Verify D:\gradle_home is working correctly
   - Test a build after Phase 1 to confirm everything works

2. **After Deletion**:
   - First build might be slower as it re-downloads some dependencies
   - If emulators stop working, you may need to recreate AVDs

3. **What We're NOT Deleting**:
   - `C:\Users\Asmit\AppData\Local\Android\sdk` - Android SDK (needed for builds)
   - Any project files on D drive

---

## 📋 Execution Steps

### Step 1: Backup Check (Optional but Recommended)
- Verify D:\gradle_home exists and has files
- Test a build to ensure D drive configuration works

### Step 2: Delete Gradle Cache
```powershell
Remove-Item -Path "C:\Users\Asmit\.gradle" -Recurse -Force
```

### Step 3: Delete Android Cache (After Confirmation)
```powershell
Remove-Item -Path "C:\Users\Asmit\.android" -Recurse -Force
```

### Step 4: Clean Temp Files (Optional)
```powershell
Get-ChildItem "C:\Users\Asmit\AppData\Local\Temp" -Filter "*flutter*" -Recurse | Remove-Item -Force -Recurse
Get-ChildItem "C:\Users\Asmit\AppData\Local\Temp" -Filter "*gradle*" -Recurse | Remove-Item -Force -Recurse
```

---

## ✅ Verification After Cleanup

1. Run a test build: `flutter build apk` or `flutter run`
2. Verify Gradle uses D:\gradle_home
3. Test emulator functionality (if .android was deleted)

---

## 🎯 Recommended Action

**Start with Phase 1 only** (delete `.gradle` folder):
- Safest option
- Recovers 0.9 GB
- Low risk since D drive has complete cache

**Then test**, and if everything works, proceed with Phase 2.

