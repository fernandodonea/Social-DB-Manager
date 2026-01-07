--SGBD Proiect



-- ex 6
-- Formulați în limbaj natural o problemă pe care să o rezolvați folosind un subprogram stocat
-- independent care să utilizeze toate cele 3 tipuri de colecții studiate. Apelați subprogramul.

-- Enunțul problemei:
-- Se dorește implementarea unei funcționalități de afișare a profilului complet pentru un utilizator specificat prin id.
-- Procedura trebuie să afișeze lista de prieteni a utilizatorului (folosind tablouri imbricate),
--  ultimele 3 grupuri în care a intrat utilizatorul (folosind vectori)
--  si o statistică a activității sale, adică numărul de postări și comentarii (folosind tablouri indexate).



CREATE OR REPLACE PROCEDURE p_afisare_profil_utilizator(
    p_id_utilizator IN UTILIZATOR.ID_UTILIZATOR%type
) IS

    --tablou imbricat pentru lista de prieteni
    TYPE t_lista_prieteni IS TABLE OF VARCHAR2(256);
    v_prieteni t_lista_prieteni :=t_lista_prieteni();

    -- vector pentru ultimele 3 grupuri
    TYPE t_istoric_grupuri IS VARRAY(3) OF VARCHAR2(256);
    v_grupuri t_istoric_grupuri := t_istoric_grupuri();

    --tablou indexat pentru statisca activitatii
    TYPE t_statistici IS TABLE OF NUMBER INDEX BY VARCHAR2(64);
    v_statistica t_statistici;

    v_nume_utilizator UTILIZATOR.NUME%type;

BEGIN

    --gasirea numelui utilizatorului
    SELECT NUME
    INTO v_nume_utilizator
    FROM UTILIZATOR
    WHERE ID_UTILIZATOR=p_id_utilizator;

    DBMS_OUTPUT.PUT_LINE('----------------------------------------');
    DBMS_OUTPUT.PUT_LINE('PROFIL UTILIZATOR: ' || v_nume_utilizator);
    DBMS_OUTPUT.PUT_LINE('----------------------------------------');
    DBMS_OUTPUT.PUT_LINE(' ');


    FOR rezultat IN
        (
            --cautam prietenii
            SELECT U.NUME
            FROM PRIETENIE P
            JOIN UTILIZATOR U ON P.ID_PRIETEN = U.ID_UTILIZATOR
            WHERE P.ID_UTILIZATOR=p_id_utilizator AND P.STATUS='ACCEPTAT'

            UNION

            SELECT U2.NUME
            FROM PRIETENIE P2
            JOIN UTILIZATOR U2 ON P2.ID_UTILIZATOR=U2.ID_UTILIZATOR
            WHERE P2.ID_PRIETEN=p_id_utilizator AND P2.STATUS='ACCEPTAT'

        ) LOOP
            v_prieteni.EXTEND;
            v_prieteni(v_prieteni.LAST):=rezultat.NUME;
        end loop;

    --Afisam prietenii
    DBMS_OUTPUT.PUT_LINE('LISTA PRIETENI:' || v_prieteni.COUNT);
    IF(v_prieteni.COUNT>0) THEN
        FOR i IN v_prieteni.FIRST .. v_prieteni.LAST LOOP
            DBMS_OUTPUT.PUT_LINE(v_prieteni(i));
        end loop;
    ELSE
        DBMS_OUTPUT.PUT_LINE('Utilizatorul nu are prieteni');
    END IF;


    --gasim ultimele grupuri in care a intrat utilizatorul (maxim 3)
    FOR rezulat IN
        (
            SELECT G.NUME_GRUP
            FROM UTILIZATOR_GRUP UG
            JOIN GRUP G ON UG.ID_GRUP = G.ID_GRUP
            WHERE UG.ID_UTILIZATOR=p_id_utilizator
            ORDER BY UG.DATA_ADERARII DESC
        ) LOOP

        IF v_grupuri.COUNT<3 THEN
            v_grupuri.extend;
            v_grupuri(v_grupuri.LAST) := rezulat.NUME_GRUP;
        end if;
    end loop;

    --afisam grupurile
    DBMS_OUTPUT.PUT_LINE(' ');
    DBMS_OUTPUT.PUT_LINE('GRUPURI RECENTE:');
    IF v_grupuri.COUNT>0 THEN

        FOR i IN v_grupuri.FIRST .. v_grupuri.LAST LOOP
            DBMS_OUTPUT.PUT_LINE(v_grupuri(i));
        end loop;
    ELSE
        DBMS_OUTPUT.PUT_LINE('Utilizatorul nu face parte din niciun grup');
    end if;


    --cream statistica despre postari, comentarii si reactii
    SELECT COUNT(*)
    INTO v_statistica('Postari')
    FROM POSTARE
    WHERE ID_UTILIZATOR=p_id_utilizator;

    SELECT COUNT(*)
    INTO v_statistica('Comentarii')
    FROM COMENTARIU
    WHERE ID_UTILIZATOR=p_id_utilizator;

    SELECT COUNT(*)
    INTO v_statistica('Reactii')
    FROM REACTIE
    WHERE ID_UTILIZATOR=p_id_utilizator;

    --afisam statistica
    DBMS_OUTPUT.PUT_LINE(' ');
    DBMS_OUTPUT.PUT_LINE('STATISTICA ACTIVITATE:');

    DBMS_OUTPUT.PUT_LINE('Postari create: ' || v_statistica('Postari'));
    DBMS_OUTPUT.PUT_LINE('Comentarii scrise: ' || v_statistica('Comentarii'));
    DBMS_OUTPUT.PUT_LINE('Reactii lasate: ' || v_statistica('Reactii'));

end;



--apelam procedura
BEGIN
    p_afisare_profil_utilizator(5);
end;
/







-- ex 7
-- Formulați în limbaj natural o problemă pe care să o rezolvați folosind un subprogram stocat
-- independent care să utilizeze 2 tipuri diferite de cursoare studiate, unul dintre acestea fiind cursor
-- parametrizat, dependent de celălalt cursor. Apelați subprogramul.


--Enunt problema
-- Se doreste afisarea postarilor prietenilor unui utilizator.
-- Procedura va folosi un cursor clasic pentru a identifica toti prietenii utilizatorlui,
-- iar apoi un ciclu cursor parametrizat care primeste ca argument id-ul prietenelui curent
-- pentru a afisa postarile acestuia



CREATE OR REPLACE PROCEDURE p_afisare_postari_prieteni(
    p_id_utilizator UTILIZATOR.ID_UTILIZATOR%type
) IS

    --cursor pentru a cauta prietenii
    CURSOR c_prieteni IS
        SELECT U.ID_UTILIZATOR, U.NUME
        FROM PRIETENIE PRT
        JOIN UTILIZATOR U ON PRT.ID_PRIETEN=U.ID_UTILIZATOR
        WHERE PRT.ID_UTILIZATOR = p_id_utilizator AND PRT.STATUS='ACCEPTAT'
        UNION
        SELECT U.ID_UTILIZATOR, U.NUME
        FROM PRIETENIE PRT
        JOIN UTILIZATOR U ON PRT.ID_UTILIZATOR=U.ID_UTILIZATOR
        WHERE PRT.ID_PRIETEN=p_id_utilizator AND PRT.STATUS='ACCEPTAT';

    --cursor pentru postarile unui utilizator
    CURSOR c_postari (c_id_prieten NUMBER) IS
        SELECT P.CONTINUT_TEXT, P.DATA_POSTARII,G.NUME_GRUP
        FROM POSTARE P
        LEFT JOIN GRUP G ON P.ID_GRUP=G.ID_GRUP
        WHERE P.ID_UTILIZATOR=c_id_prieten
        ORDER BY DATA_POSTARII DESC;

        v_nume_utilizator UTILIZATOR.NUME%type;
        v_prieten_id UTILIZATOR.ID_UTILIZATOR%type;
        v_prieten_nume UTILIZATOR.NUME%type;
        v_are_postari BOOLEAN;
BEGIN

    SELECT NUME
    INTO v_nume_utilizator
    FROM UTILIZATOR
    WHERE ID_UTILIZATOR=p_id_utilizator;



    DBMS_OUTPUT.PUT_LINE(' ');
    DBMS_OUTPUT.PUT_LINE('----------------------------------------');
    DBMS_OUTPUT.PUT_LINE('Postarile prietenilor lui ' || v_nume_utilizator);
    DBMS_OUTPUT.PUT_LINE('----------------------------------------');
    DBMS_OUTPUT.PUT_LINE(' ');


    OPEN c_prieteni;
    LOOP



        FETCH c_prieteni INTO v_prieten_id, v_prieten_nume;
        EXIT WHEN c_prieteni%NOTFOUND; --iesire cand nu mai sunt randuri

        DBMS_OUTPUT.PUT_LINE(v_prieten_nume || ':');
        DBMS_OUTPUT.PUT_LINE(' ');

        v_are_postari:=FALSE;

        FOR postare IN c_postari(v_prieten_id) LOOP

            v_are_postari:=TRUE;


            DBMS_OUTPUT.PUT_LINE(postare.CONTINUT_TEXT);
            IF postare.NUME_GRUP IS NULL THEN
                    DBMS_OUTPUT.PUT_LINE('Profil');
            ELSE
                    DBMS_OUTPUT.PUT_LINE(postare.NUME_GRUP);
            end if;
            DBMS_OUTPUT.PUT_LINE(postare.DATA_POSTARII);
            DBMS_OUTPUT.PUT_LINE(' ');


        end loop;

        IF v_are_postari = FALSE THEN
            DBMS_OUTPUT.PUT_LINE('Nicio postare');
        end if;


        DBMS_OUTPUT.PUT_LINE('----------');


    end loop;
    CLOSE c_prieteni;

end;

BEGIN
    p_afisare_postari_prieteni(5);
end;
/


-- ex 8
-- Formulați în limbaj natural o problemă pe care să o rezolvați folosind un subprogram stocat
-- independent de tip funcție care să utilizeze într-o singură comandă SQL 3 dintre tabelele create.
-- Tratați toate excepțiile care pot apărea, incluzând excepțiile predefinite NO_DATA_FOUND și
-- TOO_MANY_ROWS. Apelați subprogramul astfel încât să evidențiați toate cazurile tratate.


CREATE OR REPLACE FUNCTION f_cauta_continut (
    p_text_cautat IN VARCHAR2
) RETURN VARCHAR2
IS
    v_rezultat VARCHAR2(256);
    v_nume_utilizator VARCHAR2(256);
    v_nume_grup VARCHAR2(256);
    v_continut_text VARCHAR2(256);
BEGIN


    SELECT U.NUME, NVL(G.NUME_GRUP,'Profil Personal'), P.CONTINUT_TEXT
    INTO v_nume_utilizator, v_nume_grup, v_continut_text
    FROM POSTARE P
    JOIN UTILIZATOR U ON P.ID_UTILIZATOR = U.ID_UTILIZATOR
    LEFT JOIN GRUP G ON P.ID_GRUP = G.ID_GRUP
    WHERE UPPER(P.CONTINUT_TEXT) LIKE ('%' || TRIM(UPPER(p_text_cautat)) || '%');

    v_rezultat := 'Postare gasita cu textul "'||p_text_cautat
                      || '" | Autor: ' || v_nume_utilizator
                      || ' | Locatie: ' || v_nume_grup
                      ||'  | Cotinut : "'|| v_continut_text || '"';

    return v_rezultat;

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN 'Eroare: Nu s a gasit nicio postare cu textul "' || p_text_cautat || '"';
    WHEN TOO_MANY_ROWS THEN
        RETURN 'Eroare: Prea multe postari contin textul "' || p_text_cautat || '"';
    WHEN OTHERS THEN
        RETURN 'Eroare necunoscuta';
end;

BEGIN
    DBMS_OUTPUT.PUT_LINE(f_cauta_continut('ASC '));
end;


BEGIN
    DBMS_OUTPUT.PUT_LINE(f_cauta_continut('la'));
end;


BEGIN
    DBMS_OUTPUT.PUT_LINE(f_cauta_continut('BANANA '));
end;





--ex 9
-- Formulați în limbaj natural o problemă pe care să o rezolvați folosind un subprogram stocat
-- independent de tip procedură care să aibă minim 2 parametri și să utilizeze într-o singură
-- comandă SQL 5 dintre tabelele create. Definiți minim 2 excepții proprii, altele decât cele
-- predefinite la nivel de sistem. Apelați subprogramul astfel încât să evidențiați toate cazurile definite
-- și tratate.

-- Enunt problema
-- Sa se realizeze o procedurea care primeste ca parametru id-ul unui utilizator si un numar maxim de notificari de afisat.
-- Procedurea va afisa o lista cu utlimele notificatile ale acestuia (cereri de prietenie,
-- reactii si comentarii la postarile proprii)

CREATE OR REPLACE PROCEDURE p_notificari(
    p_id_utilizator IN VARCHAR2,
    p_limita IN NUMBER
)
IS
    v_id_utilizator UTILIZATOR.ID_UTILIZATOR%type;
    v_nume_utilizator UTILIZATOR.NUME%type;
    v_nr_notificari NUMBER :=0;

    exceptie_limita_invalida EXCEPTION;
    exceptie_user_inexistent EXCEPTION;
    exceptie_zero_notificari EXCEPTION;
BEGIN

    --verificam limita notificarilor
    BEGIN
        --nu putem avea limita negativa notificari sau un numar prea mare
        IF p_limita <=0 OR p_limita>=256 THEN
            RAISE exceptie_limita_invalida;
        end if;
    END;


    --verificam daca exista utilizatorul
    BEGIN
        SELECT U.ID_UTILIZATOR,U.NUME
        INTO v_id_utilizator,v_nume_utilizator
        FROM UTILIZATOR U
        WHERE U.ID_UTILIZATOR=p_id_utilizator;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RAISE exceptie_user_inexistent;
    END;


    DBMS_OUTPUT.PUT_LINE(' ');
    DBMS_OUTPUT.PUT_LINE('----------------------------------------');
    DBMS_OUTPUT.PUT_LINE('Ultimele'|| p_limita || ' notificari ale utilizatorului ' || v_nume_utilizator);
    DBMS_OUTPUT.PUT_LINE('----------------------------------------');
    DBMS_OUTPUT.PUT_LINE(' ');


    FOR rezultat IN
        (
            SELECT * FROM
                         (
                              --cereri de prietenie
                              SELECT U.NUME || ' ti a trimis o cere de prietenie' AS mesaj,
                                     P.DATA_TRIMITERII                           AS data_notificare
                              FROM PRIETENIE P
                                       JOIN UTILIZATOR U ON P.ID_UTILIZATOR = U.ID_UTILIZATOR
                              WHERE P.ID_PRIETEN = p_id_utilizator
                              --AND P.STATUS='ASTEPTARE' AND P.DATA_TRIMITERII >= SYSDATE - p_nr_zile


                              UNION

                              --comentarii
                              SELECT U.NUME || 'a comentat "' || C.CONTINUT_TEXT || '" la postarea ta',
                                     C.DATA_POSTARII AS data_notificare
                              FROM COMENTARIU C
                                       JOIN POSTARE POST ON C.ID_POSTARE = POST.ID_POSTARE
                                       JOIN UTILIZATOR U ON C.ID_UTILIZATOR = U.ID_UTILIZATOR
                              WHERE POST.ID_UTILIZATOR = p_id_utilizator

                              UNION

                              --reactii
                              SELECT U.NUME || ' a reactionat cu ' || R.TIP_REACTIE || ' la postarea ta' AS mesaj,
                                     R.DATA_TRIMITERII                                                   AS data_notificare

                              FROM REACTIE R
                                       JOIN POSTARE P ON R.ID_POSTARE = P.ID_POSTARE
                                       JOIN UTILIZATOR U ON R.ID_UTILIZATOR = U.ID_UTILIZATOR
                              WHERE P.ID_UTILIZATOR = p_id_utilizator


                              ORDER BY 2 DESC
                        )WHERE ROWNUM<=p_limita
        ) LOOP
            DBMS_OUTPUT.PUT_LINE(rezultat.mesaj);
            DBMS_OUTPUT.PUT_LINE(rezultat.data_notificare);
            DBMS_OUTPUT.PUT_LINE(' ');

            v_nr_notificari:=v_nr_notificari+1;
        end loop;

    IF v_nr_notificari = 0 THEN
        RAISE exceptie_zero_notificari;
    end if;

EXCEPTION
    WHEN exceptie_user_inexistent THEN
        RAISE_APPLICATION_ERROR(-20010, 'Eroare: Utilizatorul nu a fost gasit');
    WHEN exceptie_zero_notificari THEN
        RAISE_APPLICATION_ERROR(-20011, 'Eroare:Utilizatorul nu are notificari');
    WHEN exceptie_limita_invalida THEN
        RAISE_APPLICATION_ERROR(-20012, 'Eroare: Limita de notificari invalida');
    WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20013, 'Eroare necunoscuta');


end;


BEGIN
    p_notificari(1,2);
end;

BEGIN
    p_notificari(1,10);
end;

--exceptie: utilizatorul nu exista
BEGIN
    p_notificari(100,2);
end;

--exceptie: limita de notificari invalida
BEGIN
    p_notificari(1,-1);
end;

--exceptie: nu exista notificari
--TODO
BEGIN
    p_notificari(6,2);
end;

/





--ex 10
-- Definiți un trigger de tip LMD la nivel de comandă. Declanșați trigger-ul.

CREATE OR REPLACE PACKAGE p_stare_server IS
    v_mentenanta BOOLEAN :=FALSE;
END;

CREATE OR REPLACE TRIGGER trigger_modificare_mentenanta
BEFORE INSERT OR UPDATE OR DELETE ON POSTARE
BEGIN
    IF p_stare_server.v_mentenanta = TRUE THEN
        RAISE_APPLICATION_ERROR(-20014,'Sistemul este in mentenanta! Nu puteti modifica, adauga sau sterge postari!');
    end if;
end;


BEGIN
    --incercam inserarea cat timp serverul nu este in mentenanta
    DBMS_OUTPUT.PUT_LINE('Serverul este in stara normala');
    BEGIN
        INSERT INTO POSTARE (ID_UTILIZATOR, CONTINUT_TEXT)
        VALUES (1,'Test Postare');
        DBMS_OUTPUT.PUT_LINE('Succes: Postare Creata');
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE(SQLERRM);
    end;

    rollback;

    p_stare_server.v_mentenanta:=True;
    DBMS_OUTPUT.PUT_LINE('Serverul este in stare de  mentenanta');


        BEGIN
        INSERT INTO POSTARE (ID_UTILIZATOR, CONTINUT_TEXT)
        VALUES (1,'Test Postare');
        DBMS_OUTPUT.PUT_LINE('Succes: Postare Creata');
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE(SQLERRM);
    end;

    p_stare_server.v_mentenanta:=False;
end;
/



--ex 11
-- Definiți un trigger de tip LMD la nivel de linie. Declanșați trigger-ul.


-- Enuntul problemei
-- Se doreste implementarea unui sistem de moderare a comentariilor.
-- Un utilizator nu are voie sa lasa un comentariu cu limbaj neadecvat

CREATE OR REPLACE TRIGGER trigger_limbaj_licentios
BEFORE INSERT OR UPDATE OF CONTINUT_TEXT ON COMENTARIU
FOR EACH ROW
BEGIN
    IF INSTR(UPPER(:NEW.CONTINUT_TEXT),'CUVANT INTERZIS') > 0 THEN
        RAISE_APPLICATION_ERROR(-20015, 'Comentariul contine cuvinte interzie!');
    end if;
END;



BEGIN
        INSERT INTO COMENTARIU (ID_UTILIZATOR, ID_POSTARE, CONTINUT_TEXT)
        VALUES (1,1,
        'Comentariu care contine un cuvant decent'
       );



    INSERT INTO COMENTARIU (ID_UTILIZATOR, ID_POSTARE, CONTINUT_TEXT)
    VALUES (1,1,
        'Comentariu care contine un cuvant interzis'
       );

    rollback;

end;


--ex 12
--Definiți un trigger de tip LDD. Declanșați trigger-ul.

-- Enunt Problema
-- Se doreste monitorizarea tuturor modificarile asupra bazei de date.
--Orice instructie de tip LDD se va monitoriza in tabelul istoric schimbari

CREATE TABLE ISTORIC_SCHIMBARI
(
    id_schimbare NUMBER GENERATED BY DEFAULT AS IDENTITY,
    utilizator varchar2(256),
    comanda_rulata VARCHAR2(256),
    tabel_modificat VARCHAR2(256),
    data DATE
)

CREATE OR REPLACE TRIGGER trigger_schimbari_baza_date
AFTER CREATE OR DROP OR ALTER ON SCHEMA
BEGIN
    INSERT INTO ISTORIC_SCHIMBARI (utilizator, comanda_rulata, tabel_modificat,data)
    VALUES (
            USER,
            SYS.SYSEVENT,
            SYS.DICTIONARY_OBJ_NAME,
            SYSDATE
           );
end;


BEGIN
    EXECUTE IMMEDIATE 'CREATE TABLE TABEL_TEST (id_number NUMBER)';

    EXECUTE IMMEDIATE 'ALTER TABLE TABEL_TEST ADD (nume VARCHAR2(256))';

    EXECUTE IMMEDIATE 'DROP TABLE TABEL_TEST';

END;
SELECT * FROM ISTORIC_SCHIMBARI;