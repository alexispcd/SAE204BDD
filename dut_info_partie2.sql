DROP SCHEMA IF EXISTS partie2 CASCADE;

CREATE SCHEMA partie2;
SET SCHEMA 'partie2';

CREATE TABLE _individu(
    nom varchar(32),
    prenom varchar(32),
    date_naissance date,
    code_postal varchar(32),
    ville varchar(64),
    sexe char(1),
    nationalite varchar(32),
    INE varchar(32),
    CONSTRAINT _individu_pk PRIMARY KEY (INE)
);

CREATE TABLE _etudiant(
    code_nip varchar(128),
    cat_socio_etu varchar(128),
    cat_socio_parent varchar(128),
    bourse_superieur varchar(128),
    mention_bac varchar(128),
    serie_bac varchar(128),
    domainante_bac varchar(128),
    special_bac varchar(128),
    mois_annee_obtention_bac char(7),
    INE varchar(32),
    CONSTRAINT _etudiant_pk PRIMARY KEY (code_nip)
);

CREATE TABLE _candidat(
    no_candidat serial,
    classement varchar(128),
    boursier_lycee varchar(128),
    profil_candidat varchar(128),
    etablissement varchar(128),
    dept_etablissement varchar(128),
    ville_etablissement varchar(128),
    niveau_etude varchar(128),
    type_formation_prec varchar(128),
    serie_prec varchar(128),
    dominante_prec varchar(128),
    specialite_prec varchar(128),
    LV1 varchar(128),
    LV2 varchar(128),
    CONSTRAINT _candidat_pk PRIMARY KEY (no_candidat)
);

CREATE TABLE _inscription(
    groupe_tp char(2) not null,
    amenagement_evaluation varchar(50) not null,
    code_nip varchar(32),
    num_semestre char(5) not null,
    annee_univ char(9) not null,
    CONSTRAINT _inscription_pk PRIMARY KEY (code_nip, num_semestre, annee_univ)
);

CREATE TABLE _semestre(
    num_semestre char(5) not null,
    annee_univ char(9) not null,
    CONSTRAINT _semestre_pk PRIMARY KEY (num_semestre, annee_univ)
);

CREATE TABLE _module(
    id_module char(5),
    libelle_module varchar(50) not null,
    ue char(2) not null,
    CONSTRAINT _module_pk PRIMARY KEY (id_module)
);

CREATE TABLE _resultat(
    moyenne double precision not null,
    id_module char(5),
    code_nip varchar(32),
    num_semestre char(5) not null,
    annee_univ char(9) not null,
    CONSTRAINT _resultat_pk PRIMARY KEY (id_module, code_nip, num_semestre, annee_univ)
);

CREATE TABLE _programme(
    coefficient double precision not null,
    id_module char(5),
    num_semestre char(5) not null,
    annee_univ char(9) not null,
    CONSTRAINT _programme_pk PRIMARY KEY (id_module, num_semestre, annee_univ)
);

CREATE TABLE _postuler(
    INE VARCHAR(32),
    no_candidat int,
    CONSTRAINT _postuler_pk PRIMARY KEY (INE, no_candidat)
);

CREATE TABLE _s_inscrire(
    INE VARCHAR(32),
    code_nip varchar(32),
    CONSTRAINT _s_inscrire_pk PRIMARY KEY (INE, code_nip)
);

ALTER TABLE _resultat ADD
    CONSTRAINT _resultat_id_module_fk FOREIGN KEY (id_module) REFERENCES _module(id_module);
ALTER TABLE _resultat ADD
    CONSTRAINT _resultat_code_nip_fk FOREIGN KEY (code_nip) REFERENCES _etudiant(code_nip);
ALTER TABLE _resultat ADD
    CONSTRAINT _resultat_id_semestre_fk FOREIGN KEY (num_semestre, annee_univ) REFERENCES _semestre(num_semestre, annee_univ);
    
ALTER TABLE _programme ADD
    CONSTRAINT _programme_id_module_fk FOREIGN KEY (id_module) REFERENCES _module(id_module);
ALTER TABLE _programme ADD
    CONSTRAINT _programme_id_semestre_fk FOREIGN KEY (num_semestre, annee_univ) REFERENCES _semestre(num_semestre, annee_univ); 

ALTER TABLE _inscription ADD
    CONSTRAINT _inscription_code_nip_fk FOREIGN KEY (code_nip) REFERENCES _etudiant(code_nip);
ALTER TABLE _inscription ADD
    CONSTRAINT _inscription_id_semestre_fk FOREIGN KEY (num_semestre, annee_univ) REFERENCES _semestre(num_semestre, annee_univ);

ALTER TABLE _postuler ADD
    CONSTRAINT _postuler_INE_fk FOREIGN KEY (INE) REFERENCES _individu(INE);
ALTER TABLE _postuler ADD
    CONSTRAINT _postuler_no_candidat_fk FOREIGN KEY (no_candidat) REFERENCES _candidat(no_candidat);
    
ALTER TABLE _s_inscrire ADD
    CONSTRAINT _s_inscrire_INE_fk FOREIGN KEY (INE) REFERENCES _individu(INE);
ALTER TABLE _s_inscrire ADD
    CONSTRAINT _s_inscrire_code_nip_fk FOREIGN KEY (code_nip) REFERENCES _etudiant(code_nip);

set schema 'partie2';


-------------INDIVIDU----------------

WbImport -file=/home/azaaaz/Documents/INFO/SAE/SAE2.04/pt2/data/data/v_candidatures.csv
        -type=text
        -table=_individu
        -delimiter=';'
        -filecolumns=$wb_skip$,$wb_skip$,$wb_skip$,nom,prenom,sexe,date_naissance,nationalite,code_postal,ville,$wb_skip$,$wb_skip$,$wb_skip$,INE
        -dateformat="yyyy-MM-dd";
            
WbImport -file=/home/azaaaz/Documents/INFO/SAE/SAE2.04/pt2/data/data/v_inscriptions.csv
        -type=text
        -table=_individu
        -delimiter=';'
        -mode=insert,update
        -keycolumns=INE
        -filecolumns=$wb_skip$,$wb_skip$,$wb_skip$,$wb_skip$,$wb_skip$,INE,nom,prenom,date_naissance,sexe,nationalite,code_postal,ville
        -dateformat="yyyy-MM-dd";

-------------ETUDIANT----------------

WbImport -file=/home/azaaaz/Documents/INFO/SAE/SAE2.04/pt2/data/data/v_inscriptions.csv
        -type=text
        -table=_etudiant
        -delimiter=';'
        -mode=insert,update
        -keyColumns=ine
        -filecolumns=$wb_skip$,$wb_skip$,$wb_skip$,$wb_skip$,code_nip,ine,$wb_skip$,$wb_skip$,$wb_skip$,$wb_skip$,$wb_skip$,$wb_skip$,$wb_skip$,cat_socio_etu,cat_socio_parent,serie_bac,mention_bac,$wb_skip$,$wb_skip$,$wb_skip$,$wb_skip$,$wb_skip$,bourse_superieur
        -dateformat="yyyy-MM-dd";
        
WbImport -file=/home/azaaaz/Documents/INFO/SAE/SAE2.04/pt2/data/data/v_candidatures.csv
        -type=text
        -table=_etudiant
        -delimiter=';'
        -mode=update
        -keyColumns=ine
        -filecolumns=$wb_skip$,$wb_skip$,$wb_skip$,$wb_skip$,$wb_skip$,$wb_skip$,$wb_skip$,$wb_skip$,$wb_skip$,$wb_skip$,$wb_skip$,$wb_skip$,$wb_skip$,ine,$wb_skip$,$wb_skip$,$wb_skip$,$wb_skip$,$wb_skip$,$wb_skip$,$wb_skip$,$wb_skip$,dominante_bac,specialite_bac,$wb_skip$,$wb_skip$,$wb_skip$,$wb_skip$,$wb_skip$,$wb_skip$,$wb_skip$,mois_annee_obtention_bac
        -dateformat="yyyy-MM-dd";

-------------CANDIDAT----------------

WbImport -file=/home/azaaaz/Documents/INFO/SAE/SAE2.04/pt2/data/data/v_candidatures.csv
        -type=text
        -table=_candidat
        -delimiter=';'
        -filecolumns=$wb_skip$,$wb_skip$,classement,$wb_skip$,$wb_skip$,$wb_skip$,$wb_skip$,$wb_skip$,$wb_skip$,$wb_skip$,$wb_skip$,boursier_lycee,profil_candidat,$wb_skip$,$wb_skip$,etablissement,ville_etablissement,dept_etablissement,$wb_skip$,niveau_etude,type_formation_prec,serie_prec,dominante_prec,specialite_prec,lv1,lv2
        -dateformat="yyyy-MM-dd";