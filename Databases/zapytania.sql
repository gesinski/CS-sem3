/*
1. Szef chce wiedzieæ kiedy jest najwiêkszy popyt na produkty. W tym celu trzeba znaleŸæ
miesi¹c i rok z najwiêksz¹ liczb¹ zamówieñ.
*/

SELECT TOP 1 
	COUNT(*) AS liczba_zamowien, 
	YEAR(data_zamowienia) AS rok, 
	MONTH(data_zamowienia) AS miesiac
FROM Zamowienie
GROUP BY YEAR(data_zamowienia), MONTH(data_zamowienia)
ORDER BY liczba_zamowien DESC;

/*
2. Pan wysy³kowy musi siê dowiedzieæ ile paczek musi jeszcze dostarczyæ. Nale¿y
obliczyæ ile zamówieñ jest jeszcze w trakcie wysy³ki oraz ile wynosi ³¹cznie paczek.
*/

SELECT
    COUNT(DISTINCT w.zamowienie_id) AS liczba_zamowien_do_dostarczenia,
    SUM(p.liczba_paczek) AS liczba_paczek
FROM Wysylka w
LEFT JOIN Pakowanie p ON w.zamowienie_id = p.zamowienie_id
WHERE w.status_wysylki = 'W trakcie';

/*
3. Mechanicy chc¹ naprawiæ maszyny w tym celu potrzebuj¹ wizualizacji które maszyny s¹ zepsute.
Posortuj malej¹co po poborze mocy.
*/

SELECT
	maszyna_id,
	nazwa_maszyny,
	pobor_mocy
FROM Maszyna
WHERE status_maszyny = 'Zepsuta'
ORDER BY pobor_mocy DESC;

/*
4. Podaj 5 ksi¹¿ek, których zamówienia zu¿y³y najwiêcej magenty (nak³ad * iloœæ
materia³u by³a najwiêksza).
*/

SELECT TOP 5
	k.ISBN,
	k.tytul,
	(o.ile_tuszu_suma * k.naklad) AS ilosc_tuszu_na_zamowienie
FROM Ksiazka k
RIGHT JOIN Obliczenie o ON o.ISBN = k.ISBN
WHERE k.kolor_tuszu = 'Magenta'
ORDER BY ilosc_tuszu_na_zamowienie DESC;

/*
5. Podaj liczbê ksi¹¿ek, które by³y wys³ane do Gdañska w zesz³ym roku.
*/

SELECT 
    COUNT(DISTINCT z.zamowienie_id) AS liczba_ksiazek
FROM Zamowienie z
INNER JOIN Wysylka w ON w.zamowienie_id = z.zamowienie_id
WHERE 
    REVERSE(SUBSTRING(REVERSE(w.adres_dostawy), 1, CHARINDEX(' ', REVERSE(w.adres_dostawy)) - 1)) = 'Gdañsk'
AND 
    YEAR(w.data_wysylki) = YEAR(GETDATE()) - 1;

/*
6. Który klient mia³ najwiêksz¹ ³¹czn¹ masê paczek na jedno zamówienie?
*/

SELECT TOP 1
	z.zamowienie_id,
    k.nazwa AS nazwa_klienta,
    (
        SELECT p.liczba_paczek * p.waga_paczki
        FROM Pakowanie p
        WHERE p.zamowienie_id = z.zamowienie_id
    ) AS laczna_waga_paczek
FROM Zamowienie z
INNER JOIN Klient k ON k.klient_id = z.klient_id
ORDER BY laczna_waga_paczek DESC;

/*
7. Ile razy w ka¿dym miesi¹cu poprzedniego roku by³ zamawiany czarny tusz?
*/

SELECT
	MONTH(d.data_zlozenia_dostawy) AS miesiac,
	COUNT(m.rodzaj_materialu_nazwa) AS liczba_dostaw
FROM Material m
LEFT JOIN Dostawa d ON d.material_id = m.material_id
WHERE m.rodzaj_materialu_nazwa = 'Tusz czarny'
  AND YEAR(d.data_zlozenia_dostawy) = YEAR(GETDATE()) - 1
GROUP BY MONTH(d.data_zlozenia_dostawy)
ORDER BY miesiac;

/*
8. Czy twarde ok³adki sprawiaj¹, ¿e paczki s¹ ciê¿sze? Podaj 5 najwy¿szych ³¹cznych wag paczek i poka¿, 
czy zapakowane ksi¹¿ki maj¹ twarde ok³adki.
*/

SELECT TOP 5
    k.ISBN,
    k.tytul,
    p.laczna_waga_paczek,
    k.rodzaj_okladki,
    k.naklad
FROM Ksiazka k
INNER JOIN (
    SELECT 
        zamowienie_id, 
        SUM(liczba_paczek * waga_paczki) AS laczna_waga_paczek
    FROM Pakowanie
    GROUP BY zamowienie_id
) p ON k.zamowienie_id = p.zamowienie_id
ORDER BY p.laczna_waga_paczek DESC;

/*
9. Ile wynios³a cena wszystkich dostaw za grudzieñ poprzedniego roku?
*/

GO

CREATE VIEW WidokDostawyGrudzien AS
SELECT
	material_id,
	ilosc
FROM Dostawa
WHERE 
	MONTH(data_zlozenia_dostawy) = 12
AND
	YEAR(data_zlozenia_dostawy) = YEAR(GETDATE()) - 1;

GO

SELECT
	SUM(m.wartosc_zam_materialu * wdg.ilosc) AS suma_cen_dostaw
FROM Material m
INNER JOIN WidokDostawyGrudzien wdg ON m.material_id = wdg.material_id

DROP VIEW WidokDostawyGrudzien;

/*
10. Ile wynosi œrednia iloœæ stron poszczególnych formatów i który klient wyda³ ksi¹¿kê z najbli¿sz¹ iloœci¹ stron?
*/

WITH SredniaIloscStron AS (
SELECT
    k.format_ksiazki,
    AVG(k.ilosc_stron) AS srednia_ilosc_stron
FROM Ksiazka k
GROUP BY k.format_ksiazki
),
Ró¿nicaStron AS (
    SELECT
        k.zamowienie_id,
        k.tytul,
        k.format_ksiazki,
        ABS(k.ilosc_stron - s.srednia_ilosc_stron) AS roznica,
        k.ilosc_stron,
		s.srednia_ilosc_stron
    FROM Ksiazka k
    INNER JOIN SredniaIloscStron s ON k.format_ksiazki = s.format_ksiazki
),
NajblizszeKsiazki AS (
    SELECT
        r.zamowienie_id,
        r.tytul,
        r.format_ksiazki,
        r.ilosc_stron,
        r.roznica,
		r.srednia_ilosc_stron
    FROM Ró¿nicaStron r
    INNER JOIN (
        SELECT
            format_ksiazki,
            MIN(roznica) AS min_roznica
        FROM Ró¿nicaStron
        GROUP BY format_ksiazki
    ) najmniejsze ON r.format_ksiazki = najmniejsze.format_ksiazki AND r.roznica = najmniejsze.min_roznica
)
SELECT
    kl.nazwa AS klient_nazwa,
    nk.tytul AS ksiazka_tytul,
    nk.ilosc_stron,
	nk.srednia_ilosc_stron,
    nk.format_ksiazki
FROM NajblizszeKsiazki nk
INNER JOIN Zamowienie z ON nk.zamowienie_id = z.zamowienie_id
INNER JOIN Klient kl ON z.klient_id = kl.klient_id
ORDER BY nk.format_ksiazki;

