--Proiect SGBD

-- Inserari


----------------------- CREAREA UTILIZATORILOR -----------------------

INSERT INTO UTILIZATOR (nume, email, parola, telefon, cont_privat, data_inregistrarii)
VALUES (
        'Andrei Popescu',
        'andreipopescu@yahoo.com',
        'Andrei111',
        '0711111111',
        0,
        TO_DATE('01-03-2024','DD-MM-YYYY')
       );

INSERT INTO UTILIZATOR (nume, email, parola, telefon, cont_privat, data_inregistrarii)
VALUES (
        'Nicusor Ghita',
        'nicughita@gmail.com',
        'Nicu2022',
        '0722222222',
        1,
        TO_DATE('02-03-2024','DD-MM-YYYY')
       );
INSERT INTO UTILIZATOR (nume, email, parola, telefon, cont_privat, data_inregistrarii)
VALUES (
        'Ana Marinescu',
        'anamarinescu@outlook.com',
        'ParolaParola',
        '0733333333',
        0,
        TO_DATE('01-04-2024','DD-MM-YYYY')
       );
INSERT INTO UTILIZATOR (nume, email, parola, telefon, cont_privat, data_inregistrarii)
VALUES (
        'Mihaela Popa',
        'miha_popa@gmail.com',
        'Azorel2008',
        '0744444444',
        1,
        TO_DATE('02-04-2024','DD-MM-YYYY')
       );


INSERT INTO UTILIZATOR (nume, email, parola, telefon, cont_privat, data_inregistrarii)
VALUES (
        'Fernando Donea',
        'fernando@gmail.com',
        'Parola123123',
        '0777123123',
        0,
        TO_DATE('01-05-2024','DD-MM-YYYY')
       );

INSERT INTO UTILIZATOR (nume, email, parola, telefon, cont_privat, data_inregistrarii)
VALUES (
        'Gigel Gigel',
        'gigi@yahoo.com',
        'GigiProgramatoru',
        '0774567891',
        0,
        TO_DATE('02-05-2024','DD-MM-YYYY')
       );
INSERT INTO UTILIZATOR (nume, email, parola, telefon, cont_privat, data_inregistrarii)
VALUES (
        'Utilizator Sters',
        'sters@yahoo.com',
        'Parola123123',
        '0774567891',
        0,
        TO_DATE('04-05-2024','DD-MM-YYYY')
       );







-----------------------CREAREA GRUPURILOR SI INTRAREA UTILIZATORILOR IN GRUP-----------------------


----------------


INSERT INTO GRUP (nume_grup, descriere, data_crearii)
VALUES (
        'Programatorii ASC',
        'Discutii despre arhitectura sistemelor de calcul',
        TO_DATE('05-03-2024','DD-MM-YYYY')
       );

--Andrei creeaza programatorii ASC
INSERT INTO UTILIZATOR_GRUP (id_utilizator, id_grup, rol, data_aderarii)
VALUES (1,1,'ADMIN',TO_DATE('05-03-2024','DD-MM-YYYY'));


--Nicusor intra in programtorii asc
INSERT INTO UTILIZATOR_GRUP (id_utilizator, id_grup, rol, data_aderarii)
VALUES (2,1,'MEMBRU',TO_DATE('10-03-2024','DD-MM-YYYY'));


--Fernando intra in programtorii asc mai tarziu
INSERT INTO UTILIZATOR_GRUP (id_utilizator, id_grup, rol, data_aderarii)
VALUES (5,1,'MEMBRU',TO_DATE('03-05-2024','DD-MM-YYYY'));


--Gigel intra in programatorii asc mai tarziu
INSERT INTO UTILIZATOR_GRUP (id_utilizator, id_grup, rol, data_aderarii)
VALUES (6,1,'MEMBRU',TO_DATE('04-05-2024','DD-MM-YYYY'));


---------------


INSERT INTO GRUP (nume_grup, descriere, data_crearii)
VALUES (
        'Fotografii de la FMI',
        'Poze si videoclipuri ale studentilor de la FMI',
        TO_DATE('06-03-2024','DD-MM-YYYY')
       );


-- Andrei creeaza fotografii de la fmi
INSERT INTO UTILIZATOR_GRUP (id_utilizator, id_grup, rol, data_aderarii)
VALUES (1,2,'ADMIN',TO_DATE('06-03-2024','DD-MM-YYYY'));

--Ana intra in fotografii de la fmi
INSERT INTO UTILIZATOR_GRUP (id_utilizator, id_grup, rol, data_aderarii)
VALUES (3,2,'MEMBRU',TO_DATE('03-04-2024','DD-MM-YYYY'));


---------------


INSERT INTO GRUP (nume_grup, descriere, data_crearii)
VALUES (
        'Calatorii si diverse',
        'Poze din diverse locuri interesante',
        TO_DATE('05-04-2024','DD-MM-YYYY')
       );


--Nicusor creeaza grupul calatorii si diverse
INSERT INTO UTILIZATOR_GRUP (id_utilizator, id_grup, rol, data_aderarii)
VALUES (2,3,'ADMIN',TO_DATE('05-04-2024','DD-MM-YYYY'));

--Mihaela intra in calatorii si diverse
INSERT INTO UTILIZATOR_GRUP (id_utilizator, id_grup, rol, data_aderarii)
VALUES (4,3,'MEMBRU',TO_DATE('04-04-2024','DD-MM-YYYY'));


---------------


INSERT INTO GRUP (nume_grup, descriere, data_crearii)
VALUES (
        'Filme bune',
        'Recomandari de filme bune si de seriale de vizionar',
        TO_DATE('06-04-2024','DD-MM-YYYY')
       );

--Nicusor creeaza grupul filme bune
INSERT INTO UTILIZATOR_GRUP (id_utilizator, id_grup, rol, data_aderarii)
VALUES (2,4,'ADMIN',TO_DATE('06-04-2024','DD-MM-YYYY'));


--Gigel intra in filme bune
INSERT INTO UTILIZATOR_GRUP (id_utilizator, id_grup, rol, data_aderarii)
VALUES (6,4,'MEMBRU',TO_DATE('04-05-2024','DD-MM-YYYY'));


---------------


INSERT INTO GRUP (nume_grup, descriere, data_crearii)
VALUES (
        'Club de lectura',
        'Discutii rapide despre carti citite',
        TO_DATE('05-05-2024','DD-MM-YYYY')
       );

--Ana creeaza grupul clubul de lectura
INSERT INTO UTILIZATOR_GRUP (id_utilizator, id_grup, rol, data_aderarii)
VALUES (3,5,'ADMIN',TO_DATE('05-05-2024','DD-MM-YYYY'));








---------------------------- RELATIILE DE PRIETENIE   --------------------------



--Andrei-Nicusor
INSERT INTO PRIETENIE (ID_UTILIZATOR, ID_PRIETEN, STATUS, DATA_TRIMITERII)
VALUES (1, 2 , 'ACCEPTAT', TO_DATE('15-03-2024','DD-MM-YYYY'));

--Ana-Mihaela
INSERT INTO PRIETENIE (ID_UTILIZATOR, ID_PRIETEN, STATUS, DATA_TRIMITERII)
VALUES (3, 4 , 'ACCEPTAT', TO_DATE('10-04-2024','DD-MM-YYYY'));

--Fernando-Gigel
INSERT INTO PRIETENIE (ID_UTILIZATOR, ID_PRIETEN, STATUS, DATA_TRIMITERII)
VALUES (5, 6 , 'ACCEPTAT', TO_DATE('05-05-2024','DD-MM-YYYY'));


--Fernando-Andrei
INSERT INTO PRIETENIE (ID_UTILIZATOR, ID_PRIETEN, STATUS, DATA_TRIMITERII)
VALUES (1, 5 , 'ACCEPTAT', TO_DATE('10-05-2024','DD-MM-YYYY'));


--Gigel ii trimite o cerere lui Andrei
INSERT INTO PRIETENIE (ID_UTILIZATOR, ID_PRIETEN, STATUS, DATA_TRIMITERII)
VALUES (6, 1 , 'ASTEPTARE', TO_DATE('06-05-2024','DD-MM-YYYY'));

--Nicusor ii respige Mihaelei
INSERT INTO PRIETENIE (ID_UTILIZATOR, ID_PRIETEN, STATUS, DATA_TRIMITERII)
VALUES (2, 4 , 'RESPINS', TO_DATE('15-04-2024','DD-MM-YYYY'));





---------------------- CONVERSATII SI MESAJE -------------------------





--Conversatie privata dintre Andrei si Nicusor
INSERT INTO CONVERSATIE (tip_conversatie, data_crearii)
VALUES ('PRIVAT',TO_DATE('20-03-2024','DD-MM-YYYY'));

INSERT INTO UTILIZATOR_CONVERSATIE (ID_UTILIZATOR, ID_CONVERSATIE) VALUES (1, 1);--Andrei
INSERT INTO UTILIZATOR_CONVERSATIE (ID_UTILIZATOR, ID_CONVERSATIE) VALUES (2, 1);--Nicusor


INSERT INTO MESAJ (id_conversatie, id_expeditor, continut_text, data_trimiterii)
VALUES (1,1,'Buna Nicusor! Ce faci?',TO_DATE('20-03-2024','DD-MM-YYYY'));

INSERT INTO MESAJ (id_conversatie, id_expeditor, continut_text, data_trimiterii)
VALUES (1,2,'Lucram la un proiect! Tu ce faci, Andrei?',TO_DATE('20-03-2024','DD-MM-YYYY'));


---------------


--Conversatie de grup (Andrei, Nicusor, Ana)
INSERT INTO CONVERSATIE (tip_conversatie, data_crearii)
VALUES ('GRUP',TO_DATE('20-04-2024','DD-MM-YYYY'));

INSERT INTO UTILIZATOR_CONVERSATIE (ID_UTILIZATOR, ID_CONVERSATIE) VALUES (1, 2);--Andrei
INSERT INTO UTILIZATOR_CONVERSATIE (ID_UTILIZATOR, ID_CONVERSATIE) VALUES (2, 2);--Nicusor
INSERT INTO UTILIZATOR_CONVERSATIE (ID_UTILIZATOR, ID_CONVERSATIE) VALUES (3, 2);--Ana


INSERT INTO MESAJ (id_conversatie, id_expeditor, continut_text, data_trimiterii)
VALUES (2,3,'Salutari tuturor!',TO_DATE('25-04-2024','DD-MM-YYYY'));




---------------


--Conversatie privata intre Ana si Mihaela
INSERT INTO CONVERSATIE (tip_conversatie, data_crearii)
VALUES ('PRIVAT',TO_DATE('25-04-2024','DD-MM-YYYY'));

INSERT INTO UTILIZATOR_CONVERSATIE (ID_UTILIZATOR, ID_CONVERSATIE) VALUES (3, 3);--Ana
INSERT INTO UTILIZATOR_CONVERSATIE (ID_UTILIZATOR, ID_CONVERSATIE) VALUES (4, 3);--Mihaela

INSERT INTO MESAJ (id_conversatie, id_expeditor, continut_text, data_trimiterii)
VALUES (3,3,'Buna Mihaela! Mergem si noi la munte?',TO_DATE('26-04-2024','DD-MM-YYYY'));


---------------


--Conversatie privata intre Fernando si Gigel
INSERT INTO CONVERSATIE (tip_conversatie, data_crearii)
VALUES ('PRIVAT',TO_DATE('10-05-2024','DD-MM-YYYY'));

INSERT INTO UTILIZATOR_CONVERSATIE (ID_UTILIZATOR, ID_CONVERSATIE) VALUES (5, 4);--Fernando
INSERT INTO UTILIZATOR_CONVERSATIE (ID_UTILIZATOR, ID_CONVERSATIE) VALUES (6, 4);--Gigel


INSERT INTO MESAJ (id_conversatie, id_expeditor, continut_text, data_trimiterii)
VALUES (4,6,'Fernando, mergem la film maine?',TO_DATE('11-05-2024','DD-MM-YYYY'));

INSERT INTO MESAJ (id_conversatie, id_expeditor, continut_text, data_trimiterii)
VALUES (4,5,'Nu pot maine. Hai poimaine!',TO_DATE('11-05-2024','DD-MM-YYYY'));


---------------


--Conversatie de grup (Andrei, Nicusor, Fernando, Gigel)
INSERT INTO CONVERSATIE (tip_conversatie, data_crearii)
VALUES ('GRUP',TO_DATE('15-05-2024','DD-MM-YYYY'));

INSERT INTO UTILIZATOR_CONVERSATIE (ID_UTILIZATOR, ID_CONVERSATIE) VALUES (1, 5);--Andrei
INSERT INTO UTILIZATOR_CONVERSATIE (ID_UTILIZATOR, ID_CONVERSATIE) VALUES (2, 5);--Nicusor
INSERT INTO UTILIZATOR_CONVERSATIE (ID_UTILIZATOR, ID_CONVERSATIE) VALUES (5, 5);--Fernando
INSERT INTO UTILIZATOR_CONVERSATIE (ID_UTILIZATOR, ID_CONVERSATIE) VALUES (6, 5);--Gigel


INSERT INTO MESAJ (id_conversatie, id_expeditor, continut_text, data_trimiterii)
VALUES (5,6,'Cine merge la Dune 2 maine?',TO_DATE('16-05-2024','DD-MM-YYYY'));


---------------


--Conversatie privata intre Andrei si Fernando
INSERT INTO CONVERSATIE (tip_conversatie, data_crearii)
VALUES ('PRIVAT',TO_DATE('16-05-2024','DD-MM-YYYY'));

INSERT INTO UTILIZATOR_CONVERSATIE (ID_UTILIZATOR, ID_CONVERSATIE) VALUES (1, 6);--Andrei
INSERT INTO UTILIZATOR_CONVERSATIE (ID_UTILIZATOR, ID_CONVERSATIE) VALUES (5, 6);--Fernando

INSERT INTO MESAJ (id_conversatie, id_expeditor, continut_text, data_trimiterii)
VALUES (6,1,'Salut Fernando! Rezolvarea e simpla: MOV EAX EBX. Succes',TO_DATE('16-05-2024','DD-MM-YYYY'));












------------------------------POSTARI, REACTII SI COMENTARII ---------------------------


--Andrei posteaza pe grupul Programatorii ASC
INSERT INTO POSTARE (id_utilizator, id_grup, continut_text, fisier, tip_media,data_postarii)
VALUES(
       1, 1,
       'Bine ati venit pe grupul de ASC!',
       NULL, NULL,
        TO_DATE('10-03-2024','DD-MM-YYYY')
      );

--Nicusor comenteaza la postarea lui Andrei
INSERT INTO COMENTARIU (id_utilizator, id_postare, continut_text, data_postarii)
VALUES (2,1,
        'Multumim, Andrei!',
        TO_DATE('11-03-2024','DD-MM-YYYY')
       );

--Nicusor apreciaza postarea lui Andrei
INSERT INTO REACTIE (id_utilizator, id_postare, tip_reactie, data_trimiterii)
VALUES (2,1,'APRECIERE',TO_DATE('11-03-2024','DD-MM-YYYY'));


--Fernando reactioneaza cu Interesant la postarea lui Andrei
INSERT INTO REACTIE (id_utilizator, id_postare, tip_reactie, data_trimiterii)
VALUES (5,1,'APRECIERE',TO_DATE('03-05-2024','DD-MM-YYYY'));


---------------


--Nicusor posteaza in grupul Calatorii
INSERT INTO POSTARE (id_utilizator, id_grup, continut_text, fisier, tip_media,data_postarii)
VALUES(
       2, 3,
       'Saptamana trecuta am fost la munte. M-am dat si cu ski-urile',
       'munte.jpg', 'IMG',
        TO_DATE('10-04-2024','DD-MM-YYYY')
      );

--Mihaela apreciaza postarea lui Nicusor
INSERT INTO REACTIE (id_utilizator, id_postare, tip_reactie, data_trimiterii)
VALUES (4,2,'APRECIERE',TO_DATE('11-04-2024','DD-MM-YYYY'));

--Mihaela comenteaza la postarea lui Nicusor
INSERT INTO COMENTARIU (id_utilizator, id_postare, continut_text, data_postarii)
VALUES (4,2,
        'Foarte frumos peisajul. Ar intra niste aer curat la munte',
        TO_DATE('11-04-2024','DD-MM-YYYY')
       );


-------------------


--Ana posteaza pe profil
INSERT INTO POSTARE (id_utilizator, id_grup, continut_text, fisier, tip_media,data_postarii)
VALUES(
       3, NULL,
       'Prima mea postare profil!',
       NULL, NULL,
        TO_DATE('20-04-2024','DD-MM-YYYY')
      );

--Mihaela apreciaza postarea Anei de pe profil
INSERT INTO REACTIE (id_utilizator, id_postare, tip_reactie, data_trimiterii)
VALUES (4,3,'APRECIERE',TO_DATE('21-04-2024','DD-MM-YYYY'));


--Mihaela comenteaza la postarea Anei de pe profil
INSERT INTO COMENTARIU (id_utilizator, id_postare, continut_text, data_postarii)
VALUES (4,3,
        'Bine ai venit Ana!',
        TO_DATE('21-04-2024','DD-MM-YYYY')
       );


--------------------


--Ana posteaza pe clubul de lectura
INSERT INTO POSTARE (id_utilizator, id_grup, continut_text, fisier, tip_media,data_postarii)
VALUES(
       3, 5,
       'Ce ati citit interesant in utlima vreme?',
       NULL, NULL,
        TO_DATE('10-05-2024','DD-MM-YYYY')
      );


----------------------


--Fernando posteaza pe profil
INSERT INTO POSTARE (id_utilizator, id_grup, continut_text, fisier, tip_media,data_postarii)
VALUES(
       5, NULL,
       'Am fost la un concert in acest weekend. A fost super',
       'concert.mp4', 'VID',
        TO_DATE('12-05-2024','DD-MM-YYYY')
      );


-------------------------


--Fernando posteaza pe ASC
INSERT INTO POSTARE (id_utilizator, id_grup, continut_text, fisier, tip_media,data_postarii)
VALUES(
       5, 1,
       'As avea nevoie de ajutor cu ultimul exercitiul din laboratul 5. Ma poatea ajuta cineva?',
       'laborator5.jpg', 'IMG',
        TO_DATE('15-05-2024','DD-MM-YYYY')
      );


--Andrei apreciaza postarea lui Fernando
INSERT INTO REACTIE (id_utilizator, id_postare, tip_reactie, data_trimiterii)
VALUES (1,6,'INTERESANT',TO_DATE('15-05-2024','DD-MM-YYYY'));

--Andrei ii raspunde lui Fernando la postarea despre labul asc
INSERT INTO COMENTARIU (id_utilizator, id_postare, continut_text, data_postarii)
VALUES (1,6,
        'Ti-am dat mesaj cu rezolvarea pe privat',
        TO_DATE('16-05-2024','DD-MM-YYYY')
       );
--Fernando ii multumeste lui Andrei
INSERT INTO COMENTARIU (id_utilizator, id_postare, continut_text, data_postarii)
VALUES (5,6,
        'Mersi mult!',
        TO_DATE('16-05-2024','DD-MM-YYYY')
       );


---------------------


--Gigel posteaza in filme
INSERT INTO POSTARE (id_utilizator, id_grup, continut_text, fisier, tip_media,data_postarii)
VALUES(
       6, 4,
       'Recomand filmul Dune 2. L-am vazut la cinema si chiar mi a placut',
       NULL, NULL,
        TO_DATE('20-05-2024','DD-MM-YYYY')
      );

--Nicusor ii comenteaza lui Gigel
INSERT INTO COMENTARIU (id_utilizator, id_postare, continut_text, data_postarii)
VALUES (2,7,
        'Ar trebui sa ma uit si eu atunci!',
        TO_DATE('21-05-2024','DD-MM-YYYY')
       );



commit;