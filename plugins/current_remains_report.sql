select 
  *
from
  (
    select
      '350' AS kod_mo,
      'ГБУЗ СО СОКБ №1' AS name_mo,
      REPLACE(REPLACE(REPLACE (REPLACE(REPLACE(REPLACE (REPLACE
		(REPLACE(REPLACE (REPLACE(REPLACE(REPLACE (REPLACE(REPLACE
		(REPLACE (REPLACE(REPLACE(REPLACE (REPLACE(REPLACE(REPLACE
		(REPLACE(REPLACE(REPLACE (p.med_form, 'амп', 'ампулы'), 'р-ль',
		'растворитель'),'т/с', 'темного стекла'), 'па-к', 
		'пачки картонные'), 'уп-ки', 'упаковки'), 'р-р', 'раствор'), 
		'п/', 'покрытые '), 'пленоч.', 'пленочной '), 'плен.', 
		'пленочной '), 'уп.', 'упаковки '), 'упак.', 'упаковки '), 
		' п-к ', ' подкожного '), 'инф.', 'инфузий '), 'лек.', 
		'лекарственных '), 'инф ', 'инфузий '), 'в/артер.', 
		'внутриартериального ') , 'в/м', 'внутримышечного'), 'в/в', 
		'внутривенного'), 'приготовл.', 'приготовления '), 'я/к', 
		'ячейковые контурные'), 'приг.', 'приготовления '), 'р-ра', 
		'раствора') , 'пригот.', 'приготовления '), 'д/', 'для ') 
		AS med_form_o,
      p.med_doz,
      p.name_prep,
      cs3.name_cs3 AS mn,
      max(
        case
          when pd.id_oper in (11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 
		  21, 22, 23, 24, 25, 26, 27, 28, 29)
            then cs1.name_cs1
          else ''
        end) AS ist_finans,
      p.id_prep,
      a.artikul,
      p.razb_izmer AS kol_v_upak,
      a.name_provider AS name_provider,
      a.cena_gr AS cena_gr,
      a.cena_izg AS cena_izg,
      p.name_prep AS torg_name_ls,
      p.code3 AS nom_reg_udost,
      f.name_firm AS name_firm,
      max(
        case
          when pd.id_oper in (11, 12, 13, 14, 15, 16, 17, 18, 19) 
			then d.rem_doc
          else ''
        end) AS usl_ok_med_pom,
      max(
        case
          when pd.id_oper in (11, 12, 13, 14, 15, 16, 17, 18, 19) 
			then d.num_doc
          else ''
        end) AS num,
      max(
        case
          when pd.id_oper in (11, 12, 13, 14, 15, 16, 17, 18, 19) 
			then d.date_doc
          else ''
        end) AS dat,
      a.cena_opt_nds,
      s.certif_reg_num,
      d.rem_doc,
      sum(
        case
          when pd.id_oper in (11, 12, 13, 14, 15, 16, 17, 18, 19) 
			then pd.sum_opt_nds
          else 0
        end) AS suma,
      sum(
        case
          when pd.id_oper in (11, 12, 13, 14, 15, 16, 17, 18, 19) 
			then pd.kol_all / a.kol_razb
          else 0
        end) AS prihod,
      sum(
        case
          when pd.id_oper in (20, 21, 22, 23, 24, 25, 26, 27, 28, 29) 
			then pd.kol_all / a.kol_razb
          else 0
        end) AS rashod
    from
      prep p
      left join artikul a on a.id_prep = p.id_prep
      left join posdoc pd on pd.artikul = a.artikul
      left join doc d on pd.id_doc = d.id_doc
      left join custom_sprav3 cs3 on p.id_cs3 = cs3.id_cs3
      left join custom_sprav1 cs1 on d.id_cs1 = cs1.id_cs1
      left join firm f on a.id_firm = f.id_firm
      left join series s on a.artikul = s.artikul
    where
      d.date_doc between :dateBegin and :dateEnd
    group by
      p.med_form,
      p.med_doz,
      p.name_prep,
      cs3.name_cs3,
      p.id_prep,
      a.cena_opt_nds,
      a.name_provider,
      f.name_firm,
      d.rem_doc,
      p.name_lat,
      p.code3,
      p.razb_izmer,
      a.artikul,
      a.cena_izg,
      a.cena_gr,
      s.certif_reg_num
  ) z
where
     z.prihod <> 0
  or z.rashod > 0
  