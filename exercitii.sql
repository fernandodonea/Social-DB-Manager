--SGBD Proiect



-- ex 6
-- Formulați în limbaj natural o problemă pe care să o rezolvați folosind un subprogram stocat
-- independent care să utilizeze toate cele 3 tipuri de colecții studiate. Apelați subprogramul.



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








-- ex 7
-- Formulați în limbaj natural o problemă pe care să o rezolvați folosind un subprogram stocat
-- independent care să utilizeze 2 tipuri diferite de cursoare studiate, unul dintre acestea fiind cursor
-- parametrizat, dependent de celălalt cursor. Apelați subprogramul.


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
    p_afisare_postari_prieteni(6);
end;


