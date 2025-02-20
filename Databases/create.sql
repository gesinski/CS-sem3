--CREATE Drukarnia;
USE Drukarnia;

CREATE TABLE Klient (
	klient_id INT IDENTITY (1, 1) PRIMARY KEY,
	nazwa VARCHAR(50) NOT NULL,
	email VARCHAR(255) NOT NULL UNIQUE,
	telefon VARCHAR(16),
	data_dodania DATETIME NOT NULL
);

CREATE TABLE Wymagania_materialu (
	wym_materialu_id INT IDENTITY (1, 1) PRIMARY KEY,
	format_ksiazki VARCHAR(2) NOT NULL,
	typ_materialu VARCHAR(25) NOT NULL,
	wymagania_na_strone DECIMAL(10, 4) NOT NULL,
	jednostka VARCHAR(25) NOT NULL
);

CREATE TABLE Material (
	material_id INT IDENTITY (1, 1) PRIMARY KEY,
	rodzaj_materialu_nazwa VARCHAR(50) NOT NULL,
	jednostka_miary VARCHAR(10) NOT NULL,
	specyfikacja VARCHAR(50),
	opakowanie_zbiorcze VARCHAR(10) NOT NULL,
	ilosc_na_stanie DECIMAL(10, 4) NOT NULL,
	wartosc_zam_materialu DECIMAL(10, 2),
	wym_materialu_id INT NOT NULL,
	FOREIGN KEY (wym_materialu_id)
		REFERENCES Wymagania_materialu (wym_materialu_id)
);

CREATE TABLE Dostawa (
	dostawa_id INT IDENTITY (1, 1) PRIMARY KEY,
	data_zlozenia_dostawy DATETIME NOT NULL,
	status_dostawy VARCHAR(50) NOT NULL,
	ilosc INT NOT NULL,
	material_nazwa VARCHAR(25) NOT NULL,
	material_id INT NOT NULL,
	FOREIGN KEY (material_id)
		REFERENCES Material (material_id)
		ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Zamowienie (
	zamowienie_id INT IDENTITY (1, 1) PRIMARY KEY,
	data_zamowienia DATE NOT NULL,
	data_dostarczenia DATE,
	status_platnosci VARCHAR(50) NOT NULL,
	status_zamowienia VARCHAR(50) NOT NULL,
	klient_id INT NOT NULL,
	FOREIGN KEY (klient_id)
		REFERENCES Klient (klient_id)
		ON DELETE CASCADE ON UPDATE CASCADE,
	dostawa_id INT FOREIGN KEY 
		REFERENCES Dostawa (dostawa_id)
		ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Ksiazka (
	ISBN VARCHAR(13) PRIMARY KEY,
	format_ksiazki VARCHAR(2) NOT NULL,
	tytul VARCHAR(100) NOT NULL,
	naklad INT CHECK (naklad>0),
	rodzaj_papieru VARCHAR(25) NOT NULL,
	rodzaj_okladki VARCHAR(25) NOT NULL,
	ilosc_stron INT CHECK (ilosc_stron>0),
	kolor_tuszu VARCHAR(25) NOT NULL,
	zamowienie_id INT NOT NULL,
	FOREIGN KEY (zamowienie_id)
		REFERENCES Zamowienie (zamowienie_id)
		ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Obliczenie (
	obliczenia_id INT IDENTITY (1, 1) PRIMARY KEY,
	ISBN VARCHAR(13) NOT NULL,
	ile_tuszu_suma DECIMAL(10, 4) DEFAULT 0,
	ile_papieru_suma DECIMAL(10, 4) DEFAULT 0,
	FOREIGN KEY (ISBN)
		REFERENCES Ksiazka (ISBN)
		ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Zapotrzebowanie (
	zapotrzebowanie_id INT IDENTITY (1, 1) PRIMARY KEY,
	zamowienie_id INT NOT NULL,
	FOREIGN KEY (zamowienie_id)
		REFERENCES Zamowienie (zamowienie_id)
		ON DELETE CASCADE ON UPDATE CASCADE,
	material_id INT NOT NULL,
	FOREIGN KEY (material_id)
		REFERENCES Material(material_id)
		ON DELETE NO ACTION ON UPDATE NO ACTION,
	obliczenia_id INT NOT NULL,
	FOREIGN KEY (obliczenia_id)
		REFERENCES Obliczenie (obliczenia_id),
	ilosc_materialu INT NOT NULL,
	jednostka_materialu VARCHAR(25) NOT NULL
);

CREATE TABLE Drukowanie (
	drukowanie_id INT IDENTITY (1, 1) PRIMARY KEY,
	data_poczatku_druku DATETIME NOT NULL,
	data_zakonczenia_druku DATETIME,
	status_drukowania VARCHAR(50) NOT NULL,
	zamowienie_id INT NOT NULL,
	FOREIGN KEY (zamowienie_id)
		REFERENCES Zamowienie (zamowienie_id)
		ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Maszyna (
	maszyna_id INT IDENTITY (1, 1) PRIMARY KEY,
	nazwa_maszyny VARCHAR(255) NOT NULL,
	typ_maszyny VARCHAR(25) NOT NULL,
	pobor_mocy INT NOT NULL,
	data_ostatniej_konserwacji DATE NOT NULL,
	status_maszyny VARCHAR(25) NOT NULL,
	drukowanie_id INT NOT NULL,
	FOREIGN KEY (drukowanie_id)
		REFERENCES Drukowanie (drukowanie_id)
		ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Wysylka (
	wysylka_id INT IDENTITY (1, 1) PRIMARY KEY,
	adres_dostawy VARCHAR(255),
	data_wysylki DATETIME,
	status_wysylki VARCHAR(25) NOT NULL,
	zamowienie_id INT NOT NULL,
	FOREIGN KEY (zamowienie_id)
		REFERENCES Zamowienie (zamowienie_id)
		ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Pakowanie (
	pakowanie_id INT IDENTITY (1, 1) PRIMARY KEY,
	data_pakowania DATE,
	liczba_paczek INT,
	waga_paczki DECIMAL(10, 2),
	zamowienie_id INT NOT NULL,
	FOREIGN KEY (zamowienie_id)
		REFERENCES Zamowienie (zamowienie_id)
		ON DELETE CASCADE ON UPDATE CASCADE
);