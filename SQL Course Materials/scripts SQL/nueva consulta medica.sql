ALTER TABLE ANAMNESIS.consulta_medica ADD(onco_mot_quimioterpia CHAR(2), onco_mot_hormonterpia CHAR(2),
                                onco_mot_Inmunoterpia CHAR(2), onco_mot_Terapia_dirigida CHAR(2),
                                onco_mot_radioterapia CHAR(2), onco_mot_primera_consulta CHAR(2),

                                onco_mot_Control CHAR(2), onco_mot_Urgencia CHAR(2),
                                onco_mot_neoadyuvancia CHAR(2), onco_mot_Adyuvancia CHAR(2),
                                onco_mot_Metastasico CHAR(2), onco_mot_otros CHAR(2),
                                onco_mot_descripcion_otros varchar2(4000),


                                onco_hist_diag_oncologico VARCHAR2(4000), onco_hist_fecha_diagnostico_ap VARCHAR2(4000),
                                onco_hist_Biopsia_puncion CHAR(2), onco_hist_Biopsia_incisional CHAR(2),
                                onco_hist_Biopsia_escisional CHAR(2), onco_hist_Otros char(2),
                                onco_hist_descripcion_Otros char(2),

                                onco_hist_inmunohistoquimica VARCHAR2(4000), onco_hist_test_mutacional_gene varchar2(4000),

                                onco_hist_Estadif_clinica VARCHAR2(4000), onco_hist_Estadif_patologica varchar2(4000),

                                onco_tra_Cirugia VARCHAR2(4000), onco_tra_radioterapia varchar2(4000),

                                onco_quimio_otros VARCHAR2(4000), onco_val_examen_fisico_ecog VARCHAR2(4000),
                                onco_est_imagen VARCHAR2(4000), onco_est_laboratorio VARCHAR2(4000),
                                onco_est_marcadores_tumorales VARCHAR2(4000), onco_ind_cirugia CHAR(2),
                                onco_ind_Tratamiento_dirigida CHAR(2), onco_ind_radioterapia CHAR(2),
                                onco_ind_hormonoterapia CHAR(2), onco_ind_qt_oral CHAR(2),
                                onco_ind_inmunoterapia CHAR(2), onco_ind_qt_parenteral CHAR(2),
                                onco_ind_ac_zoledronico CHAR(2), onco_ind_otros CHAR(2),
                                onco_ind_descripcion_otros varchar2(4000), onco_ind_esquema_quimioterapia varchar2(4000),
                                onco_ind_tra_cirugia CHAR(2), onco_ind_tra_farmacologica char(2),
                                )





	Quimioterpia				Primera consulta		Neoadyuvancia

Hormonterpia				Control		Adyuvancia

Inmunoterpia				Urgencia		Metastásico

Terapia dirigida				Otros	Texto libre

Radioterapia





