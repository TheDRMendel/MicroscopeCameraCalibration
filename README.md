# Duplamikroszkóp Képeinek Egymásra Kalibrálása

## Leírás
Ez a kód két kép kalibrálására szolgál, amelyeket egy duplamikroszkóppal vettek fel, hogy azokat egymáshoz igazítsa további elemzés vagy feldolgozás céljából. A program két képet olvas be, az egyik RGB formátumban, a másik pedig szürkeárnyalatosan. Manuálisan kiválasztott ellenőrzőpontok alapján kalibrálja azokat, majd egyesíti a képeket úgy, hogy az átalakított RGB képet ráhelyezi a szürkeárnyalatos képre.

## Használat
1. Győződjön meg róla, hogy a szükséges képek a megfelelő könyvtárban találhatóak (`Images/Pontok/SZ/` és `Images/Pontok/FF/` ebben az esetben).
2. Távolítsa el a kód sorából a megjegyzéseket és állítsa be az útvonalakat, hogy betöltse a kívánt képeket.
3. Opcionálisan manuálisan válassza ki az ellenőrzőpontokat a `cpselect` függvény segítségével, vagy töltsön be előre elmentett ellenőrzőpontokat a `load` függvény használatával.
4. Futtassa le a kódot a kalibrálás és a képek igazítása érdekében.
5. A kapott egyesített kép és a különbségkép, amely a kalibrált képek közötti különbségeket mutatja, megjelenik.

## Függőségek
- MATLAB Képfeldolgozó Toolbox

## Fájlstruktúra
- `README.md`: Ez a fájl, amely áttekintést nyújt a projektről és használati utasításokat tartalmaz.
- `calibrate_images.m`: MATLAB script a képek kalibrálásához és igazításához.
- `Images/`: Könyvtár, amely a kalibráláshoz szükséges mintaképeket tartalmazza.
- `Data/`: Könyvtár a manuális adatok és a transzformációs mátrixok tárolásához.

## Használati útmutató
1. **Képek Betöltése**: 
   - Módosítsa a kódban az útvonalakat, hogy betöltse a kívánt képeket (`rgbImage` és `grayImage` változók).
2. **Manuális Ellenőrzőpont Kiválasztása** (Opcionális):
   - Távolítsa el a megjegyzéseket és futtassa a `cpselect` függvényt, hogy manuálisan kiválassza az ellenőrzőpontokat.
   - Mentse el az ellenőrzőpontokat a `save` függvény segítségével a későbbi felhasználáshoz.
3. **Kalibrálás és Igazítás**:
   - Futtassa a scriptet a kalibrálás és az igazítás elvégzéséhez affin transzformációval.
   - A transzformációs mátrix (`tform`) kiszámítódik és megjelenik.
4. **Képek Egyesítése**:
   - Az RGB képet átalakítja és ráhelyezi a szürkeárnyalatos képre, hogy létrehozza az egyesített képet.
   - A fekete területeket kiszűri az átalakított RGB képen.
5. **Vizualizáció**:
   - Az egyesített képet és a különbségképet megjeleníti, hogy értékelje a kalibrálás minőségét.
