# Duplamikroszkóp Képeinek Egymásra Kalibrálása

## Leírás
Ez egy duplamikroszkóp által készített képek egymásra illesztésére szolgál. A program beolvassa a két képet. Manuálisan kiválasztott ellenőrzőpontok alapján meghatározza a közük lévő transzformációs mátrixot, majd egyesíti a képeket úgy, hogy az átalakított RGB képet ráhelyezi a szürkeárnyalatos képre.

## Használat
1. Mentse le a github repo-t!
2. Futassa a Matlab szkriptet!

## Működési feltételek
- MATLAB Képfeldolgozó Toolbox

## Rövid program leírás
1. **Képek Betöltése**: 
   - Módosítsa a kódban az útvonalakat, hogy betöltse a kívánt képeket (`rgbImage` és `grayImage` változók).
2. **Kalibrálás és Igazítás**:
   - Transzformáció mátrix kiszámítása
   - Egyik kép transzformálása a másik koordinátarendszerébe
3. **Képek Egyesítése**:
   - A program egymásra illeszti a két képet
4. **Képek különbségének számítása**:
   - A két kép RGB különségét képezzük, ahol a két kép különbsége értelmezett.
5. **Vizualizáció**:
   - Az egyesített képet és a különbségképet megjeleníti, hogy értékelje a kalibrálás minőségét.
