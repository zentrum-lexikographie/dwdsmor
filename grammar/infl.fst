% infl.fst
% Version 3.1
% Andreas Nolda 2023-03-10

% based on code from SMORLemma by Rico Sennrich
% which is in turn based on code from SMOR by Helmut Schmid

$SS$ = <OLDORTH>:<SSalt> | <>:<SS>


% nouns

% Frau; Mythos; Chaos
$NSg_0$ = {<NGDA><Sg>}:{<FB>}

% Mensch-en
$NSg_en$ = {<Nom><Sg>}:{<FB>}   | \
           {<GDA><Sg>}:{<FB>en} | \
           {<DA><Sg><NonSt>}:{<FB>} % cf. Duden-Grammatik (2016: § 333)

% Nachbar-n
$NSg_n$ = {<Nom><Sg>}:{<FB>} | \
          {<GDA><Sg>}:{<FB>n}

% Haus-es, Geist-(e)s
$NSg_es$ = {<NDA><Sg>}:{<FB>}         | \
           {<Gen><Sg>}:{<FB>es<^Gen>} | \
           {<Dat><Sg><Old>}:{<FB>e} % cf. Duden-Grammatik (2016: § 317)

% Opa-s, Klima-s
$NSg_s$ = {<NDA><Sg>}:{<FB>} | \
          {<Gen><Sg>}:{<FB>s}

$NPl_0$ = {<NGA><Pl>}:{} | \
          {<Dat><Pl>}:{n}

$NPl_x$ = {<NGDA><Pl>}:{}

$N_0_\$$ =           $NSg_0$ | \
           {}:{<UL>} $NPl_0$

$N_0_\$e$ =            $NSg_0$ | \
            {}:{<UL>e} $NPl_0$

$N_0_e$ =            $NSg_0$ | \
          {}:{<FB>e} $NPl_0$

$N_0_en$ =             $NSg_0$ | \
           {}:{<FB>en} $NPl_x$

$N_0_\$en$ =             $NSg_0$ | \
             {}:{<UL>en} $NPl_x$

$N_0_n$ =            $NSg_0$ | \
          {}:{<FB>n} $NPl_x$

$N_0_es$ =             $NSg_0$ | \
           {}:{<FB>es} $NPl_x$

$N_0_s$ =            $NSg_0$ | \
          {}:{<FB>s} $NPl_x$

$N_0_x$ = $NSg_0$ | \
          $NPl_x$

$N_en_en$ =             $NSg_en$ | \
            {}:{<FB>en} $NPl_x$

$N_es_\$e$ =            $NSg_es$ | \
             {}:{<UL>e} $NPl_0$

$N_es_\$er$ =             $NSg_es$ | \
              {}:{<UL>er} $NPl_0$

$N_es_er$ =         $NSg_es$ | \
            {}:{er} $NPl_0$

$N_es_e$ =            $NSg_es$ | \
           {}:{<FB>e} $NPl_0$

$N_es_en$ =             $NSg_es$ | \
            {}:{<FB>en} $NPl_x$

$N_es_es$ =             $NSg_es$ | \
            {}:{<FB>es} $NPl_x$

$N_es_s$ =            $NSg_es$ | \
           {}:{<FB>s} $NPl_x$

$N_n_n$ =            $NSg_n$ | \
          {}:{<FB>n} $NPl_x$

$N_s_0$ = $NSg_s$ | \
          $NPl_0$

$N_s_\$$ =           $NSg_s$ | \
           {}:{<UL>} $NPl_0$

$N_s_\$x$ =           $NSg_s$ | \
            {}:{<UL>} $NPl_x$

$N_s_e$ =            $NSg_s$ | \
          {}:{<FB>e} $NPl_0$

$N_s_\$e$ =              $NSg_s$ | \
            {<>}:{<UL>e} $NPl_0$

$N_s_en$ =             $NSg_s$ | \
           {}:{<FB>en} $NPl_x$

$N_s_er$ =             $NSg_s$ | \
           {}:{<FB>er} $NPl_x$

$N_s_\$er$ =               $NSg_s$ | \
             {<>}:{<UL>er} $NPl_0$

$N_s_n$ =            $NSg_s$ | \
          {}:{<FB>n} $NPl_x$

$N_s_s$ =            $NSg_s$ | \
          {}:{<FB>s} $NPl_x$

$N_s_x$ = $NSg_s$ | \
          $NPl_x$


% feminine nouns

% Matrix/--
$NFem/Sg_0$ = {<+NN><Fem>}:{} $NSg_0$

% --/Matrizen
$NFem/Pl_x$ = {<+NN><Fem>}:{} $NPl_x$

% Mutter/Mütter
$NFem_0_\$$ = {<+NN><Fem>}:{} $N_0_\$$

% Wand/Wände
$NFem_0_\$e$ = {<+NN><Fem>}:{} $N_0_\$e$

% Drangsal/Drangsale; Retina/Retinae
$NFem_0_e$ = {<+NN><Fem>}:{} $N_0_e$

% Frau/Frauen; Arbeit/Arbeiten
$NFem_0_en$ = {<+NN><Fem>}:{} $N_0_en$

% Werkstatt/Werkstätten
$NFem_0_\$en$ = {<+NN><Fem>}:{} $N_0_\$en$

% Hilfe/Hilfen; Tafel/Tafeln; Nummer/Nummern
$NFem_0_n$ = {<+NN><Fem>}:{} $N_0_n$

% Smartwatch/Smartwatches
$NFem_0_es$ = {<+NN><Fem>}:{} $N_0_es$

% Oma/Omas
$NFem_0_s$ = {<+NN><Fem>}:{} $N_0_s$

% Ananas/Ananas
$NFem_0_x$ = {<+NN><Fem>}:{} $N_0_x$

% Hosteß/Hostessen
$NFem-s/ssen$ = $SS$ {<+NN><Fem>}:{} $N_0_en$

% Kenntnis/Kenntnisse
$NFem-s/sse$ = $SS$ {<+NN><Fem>}:{} $N_0_e$

% Nuß/Nüsse
$NFem-s/\$sse$ = $SS$ {<+NN><Fem>}:{} $N_0_\$e$

% Freundin/Freundinnen
$NFem-in$ =          $NFem/Sg_0$ | \
            {}:{nen} $NFem/Pl_x$

% Algebra/Algebren; Firma/Firmen
$NFem-a/en$ =              $NFem/Sg_0$ | \
              {}:{<^pl>en} $NFem/Pl_x$

% Basis/Basen
$NFem-is/en$ =              $NFem/Sg_0$ | \
               {}:{<^pl>en} $NFem/Pl_x$

% Neuritis/Neuritiden
$NFem-is/iden$ =                $NFem/Sg_0$ | \
                 {}:{<^pl>iden} $NFem/Pl_x$

% Frauenbeauftragte, Illustrierte
$NFem-Adj$ = {<+NN><Fem><NA><Sg><SW>}:{}   | \
             {<+NN><Fem><NA><Pl><St>}:{}   | \
             {<+NN><Fem><GD><Sg><St>}:{r}  | \
             {<+NN><Fem><GD><Sg><Wk>}:{n}  | \
             {<+NN><Fem><NGA><Pl><Wk>}:{n} | \
             {<+NN><Fem><Dat><Pl><SW>}:{n} | \
             {<+NN><Fem><Gen><Pl><St>}:{r}


% masculine nouns

% Fiskus/--
$NMasc/Sg_0$ = {<+NN><Masc>}:{} $NSg_0$

% Abwasch-(e)s/--; Glanz-es/--;
$NMasc/Sg_es$ = {<+NN><Masc>}:{} $NSg_es$

% Hagel-s/--; Adel-s/--
$NMasc/Sg_s$ = {<+NN><Masc>}:{} $NSg_s$

% --/Kurse
$NMasc/Pl_0$ = {<+NN><Masc>}:{} $NPl_0$

% --/Bauten
$NMasc/Pl_x$ = {<+NN><Masc>}:{} $NPl_x$

% Intercity/Intercitys
$NMasc_0_s$ = {<+NN><Masc>}:{} $N_0_s$

% Revers/Revers
$NMasc_0_x$ = {<+NN><Masc>}:{} $N_0_x$

% Tag-(e)s/Tage
$NMasc_es_e$ = {<+NN><Masc>}:{} $N_es_e$

% Arzt-(e)s/Ärzte
$NMasc_es_\$e$ = {<+NN><Masc>}:{} $N_es_\$e$

% Gott-(e)s/Götter
$NMasc_es_\$er$ = {<+NN><Masc>}:{} $N_es_\$er$

% Tenor-s/Tenöre
$NMasc_s_\$e$ = {<+NN><Masc>}:{<>} $N_s_\$e$

% Geist-(e)s/Geister
$NMasc_es_er$ = {<+NN><Masc>}:{<>} $N_es_er$

% Fleck-(e)s/Flecken
$NMasc_es_en$ = {<+NN><Masc>}:{} $N_es_en$

% Bugfix-(e)s/Bugfixes
$NMasc_es_es$ = {<+NN><Masc>}:{} $N_es_es$

% Park-(e)s/Parks
$NMasc_es_s$ = {<+NN><Masc>}:{} $N_es_s$

% Adler-s/Adler; Engel-s/Engel
$NMasc_s_0$ = {<+NN><Masc>}:{} $N_s_0$

% Apfel-s/Äpfel; Vater-s/Väter
$NMasc_s_\$$ = {<+NN><Masc>}:{} $N_s_\$$

% Wagen-s/Wagen
$NMasc_s_x$ = {<+NN><Masc>}:{} $N_s_x$

% Garten-s/Gärten
$NMasc_s_\$x$ = {<+NN><Masc>}:{} $N_s_\$x$

% Drilling-s/Drillinge
$NMasc_s_e$ = {<+NN><Masc>}:{} $N_s_e$

% Zeh-s/Zehen
$NMasc_s_en$ = {<+NN><Masc>}:{} $N_s_en$

% Ski-s/Skier
$NMasc_s_er$ = {<+NN><Masc>}:{} $N_s_er$

% Irrtum-s/Irrtümer
$NMasc_s_\$er$ = {<+NN><Masc>}:{} $N_s_\$er$

% Muskel-s/Muskeln; See-s/Seen
$NMasc_s_n$ = {<+NN><Masc>}:{} $N_s_n$

% Chef-s/Chefs; Bankier-s/Bankiers
$NMasc_s_s$ = {<+NN><Masc>}:{} $N_s_s$

% Fels-en/Felsen; Mensch-en/Menschen
$NMasc_en_en$ = {<+NN><Masc>}:{} $N_en_en$

% Affe-n/Affen; Bauer-n/Bauern
$NMasc_n_n$ = {<+NN><Masc>}:{} $N_n_n$

% Haß-Hasses/--
$NMasc-s/Sg$ = $SS$ {<+NN><Masc>}:{} $NSg_es$

% Nimbus-/Nimbusse
$NMasc-s0/sse$ = $SS$ {<+NN><Masc>}:{} $N_0_e$

% Bus/Busse; Erlaß/Erlasse
$NMasc-s/sse$ = $SS$ {<+NN><Masc>}:{} $N_es_e$

% Baß/Bässe
$NMasc-s/\$sse$ = $SS$ {<+NN><Masc>}:{} $N_es_\$e$

% Name-ns/Namen; Gedanke(n); Buchstabe
$NMasc-ns$ = {<+NN><Masc><Nom><Sg>}:{}       | \
             {<+NN><Masc><Gen><Sg>}:{<FB>ns} | \
             {<+NN><Masc><DA><Sg>}:{<FB>n}   | \
             {<+NN><Masc>}:{n}               $NPl_x$

% Embryo/Embryonen (masculine)
$NMasc_0_nen$ =          $NMasc/Sg_0$ | \
                {}:{nen} $NMasc/Pl_x$

% Embryo-s/Embryonen (masculine)
$NMasc_s_nen$ =          $NMasc/Sg_s$ | \
                {}:{nen} $NMasc/Pl_x$

% Saldo/Salden
$NMasc-o/en$ =              $NMasc/Sg_s$ | \
               {}:{<^pl>en} $NMasc/Pl_x$

% Saldo/Saldi
$NMasc-o/i$ =             $NMasc/Sg_s$ | \
              {}:{<^pl>i} $NMasc/Pl_x$

% Atlas/Atlanten
$NMasc-as0/anten$ =                 $NMasc/Sg_0$ | \
                    {}:{<^pl>anten} $NMasc/Pl_x$

% Atlas-ses/Atlanten
$NMasc-as/anten$ =                 $NMasc-s/Sg$ | \
                   {}:{<^pl>anten} $NMasc/Pl_x$

% Kursus/Kurse
$NMasc-us/e$ =             $NMasc/Sg_0$ | \
               {}:{<^pl>e} $NMasc/Pl_0$

% Virus/Viren
$NMasc-us0/en$ =              $NMasc/Sg_0$ | \
                 {}:{<^pl>en} $NMasc/Pl_x$

% Virus-se/Viren
$NMasc-us/en$ =              $NMasc-s/Sg$ | \
                {}:{<^pl>en} $NMasc/Pl_x$

% Intimus/Intimi
$NMasc-us0/i$ =            $NMasc/Sg_0$ | \
               {}:{<^pl>i} $NMasc/Pl_x$

% Intimus-se/Intimi
$NMasc-us/i$ =             $NMasc-s/Sg$ | \
               {}:{<^pl>i} $NMasc/Pl_x$

% Beamte(r); Gefreite(r)
$NMasc-Adj$ = {<+NN><Masc><Nom><Sg><Wk>}:{}  | \
              {<+NN><Masc><NA><Pl><St>}:{}   | \
              {<+NN><Masc><Dat><Sg><St>}:{m} | \
              {<+NN><Masc><GA><Sg><SW>}:{n}  | \
              {<+NN><Masc><Dat><Sg><Wk>}:{n} | \
              {<+NN><Masc><NGA><Pl><Wk>}:{n} | \
              {<+NN><Masc><Dat><Pl><SW>}:{n} | \
              {<+NN><Masc><Nom><Sg><St>}:{r} | \
              {<+NN><Masc><Gen><Pl><St>}:{r}


% neuter nouns

% Abseits-/--
$NNeut/Sg_0$ = {<+NN><Neut>}:{} $NSg_0$

% Ausland-(e)s/--
$NNeut/Sg_es$ = {<+NN><Neut>}:{} $NSg_es$

% Abitur-s/--
$NNeut/Sg_s$ = {<+NN><Neut>}:{} $NSg_s$

% --/Fresken
$NNeut/Pl_x$ = {<+NN><Neut>}:{} $NPl_x$

% College/Colleges
$NNeut_0_s$ = {<+NN><Neut>}:{} $N_0_s$

% Relais-/Relais
$NNeut_0_x$ = {<+NN><Neut>}:{} $N_0_x$

% Spiel-(e)s/Spiele; Abgas-es/Abgase
$NNeut_es_e$ = {<+NN><Neut>}:{} $N_es_e$

% Floß-es/Flöße;
$NNeut_es_\$e$ = {<+NN><Neut>}:{} $N_es_\$e$

% Schild-(e)s/Schilder
$NNeut_es_er$ = {<+NN><Neut>}:{} $N_es_er$

% Buch-(e)s/Bücher
$NNeut_es_\$er$ = {<+NN><Neut>}:{} $N_es_\$er$

% Bett-(e)s/Betten
$NNeut_es_en$ = {<+NN><Neut>}:{} $N_es_en$

% Match-(e)s/Matches
$NNeut_es_es$ = {<+NN><Neut>}:{} $N_es_es$

% Tablett-(e)s/Tabletts
$NNeut_es_s$ = {<+NN><Neut>}:{} $N_es_s$

% Feuer-s/Feuer; Mittel-s/Mittel
$NNeut_s_0$ = {<+NN><Neut>}:{} $N_s_0$

% Kloster-s/Klöster
$NNeut_s_\$$ = {<+NN><Neut>}:{} $N_s_\$$

% Almosen-s/Almosen
$NNeut_s_x$ = {<+NN><Neut>}:{} $N_s_x$

% Dreieck-s/Dreiecke
$NNeut_s_e$ = {<+NN><Neut>}:{} $N_s_e$

% Juwel-s/Juwelen
$NNeut_s_en$ = {<+NN><Neut>}:{} $N_s_en$

% Spital-s/Spitäler
$NNeut_s_\$er$ = {<+NN><Neut>}:{} $N_s_\$er$

% Auge-s/Augen
$NNeut_s_n$ = {<+NN><Neut>}:{} $N_s_n$

% Sofa-s/Sofas; College-s/Colleges
$NNeut_s_s$ = {<+NN><Neut>}:{} $N_s_s$

% Herz-ens
$NNeut-Herz$ = {<+NN><Neut><NA><Sg>}:{<FB>}     | \
               {<+NN><Neut><Gen><Sg>}:{<FB>ens} | \
               {<+NN><Neut><Dat><Sg>}:{<FB>en}  | \
               {<+NN><Neut><NGDA><Pl>}:{<FB>en}

% Innern
$NNeut-Inner$ = {<+NN><Neut><NA><Sg><Wk>}:{<FB>e}   | \
                {<+NN><Neut><Dat><Sg><St>}:{<FB>em} | \
                {<+NN><Neut><Gen><Sg><SW>}:{<FB>en} | \
                {<+NN><Neut><Gen><Sg><SW>}:{<FB>n}  | \
                {<+NN><Neut><Dat><Sg><Wk>}:{<FB>en} | \
                {<+NN><Neut><Dat><Sg><Wk>}:{<FB>n}  | \
                {<+NN><Neut><NA><Sg><St>}:{<FB>es}

% Verständnis/--
$NNeut/Sg_sses$ = $SS$ $NNeut/Sg_es$

% Zeugnis/Zeugnisse
$NNeut-s/sse$ = $SS$ $NNeut_es_e$

% Faß/Fässer
$NNeut-s/\$sser$ = $SS$ $NNeut_es_\$er$

% Adverb/Adverbien
$NNeut_s_ien$ =          $NNeut/Sg_s$ | \
                {}:{ien} $NNeut/Pl_x$

% Embryo/Embryonen (neuter)
$NNeut_0_nen$ =          $NNeut/Sg_0$ | \
                {}:{nen} $NNeut/Pl_x$

% Embryo-s/Embryonen (neuter)
$NNeut_s_nen$ =          $NNeut/Sg_s$ | \
                {}:{nen} $NNeut/Pl_x$

% Komma/Kommata
$NNeut-a/ata$ =         $NNeut/Sg_s$ | \
                {}:{ta} $NNeut/Pl_x$

% Dogma/Dogmen
$NNeut-a/en$ =              $NNeut/Sg_s$ | \
               {}:{<^pl>en} $NNeut/Pl_x$

% Examen/Examina
$NNeut-en/ina$ =               $NNeut/Sg_s$ | \
                 {}:{<^pl>ina} $NNeut/Pl_x$

% Konto/Konten
$NNeut-o/en$ =              $NNeut/Sg_s$ | \
               {}:{<^pl>en} $NNeut/Pl_x$

% Cello/Celli
$NNeut-o/i$ =             $NNeut/Sg_s$ | \
              {}:{<^pl>i} $NNeut/Pl_x$

% Oxymoron/Oxymora
$NNeut-on/a$ =             $NNeut/Sg_s$ | \
               {}:{<^pl>a} $NNeut/Pl_x$

% Stadion/Stadien
$NNeut-on/en$ =              $NNeut/Sg_s$ | \
                {}:{<^pl>en} $NNeut/Pl_x$

% Aktivum/Aktiva
$NNeut-um/a$ =             $NNeut/Sg_s$ | \
               {}:{<^pl>a} $NNeut/Pl_x$

% Museum/Museen
$NNeut-um/en$ =              $NNeut/Sg_s$ | \
                {}:{<^pl>en} $NNeut/Pl_x$

% Virus/Viren
$NNeut-us0/en$ =              $NNeut/Sg_0$ | \
                 {}:{<^pl>en} $NNeut/Pl_x$

% Junge(s) ('young animal')
$NNeut-Adj$ = {<+NN><Neut><NA><Sg><Wk>}:{}   | \
              {<+NN><Neut><NA><Pl><St>}:{}   | \
              {<+NN><Neut><Dat><Sg><St>}:{m} | \
              {<+NN><Neut><Gen><Sg><SW>}:{n} | \
              {<+NN><Neut><Dat><Sg><Wk>}:{n} | \
              {<+NN><Neut><NGA><Pl><Wk>}:{n} | \
              {<+NN><Neut><Dat><Pl><SW>}:{n} | \
              {<+NN><Neut><Gen><Pl><St>}:{r} | \
              {<+NN><Neut><NA><Sg><St>}:{s}

% (das/etwas) Deutsche(s)
$NNeut-Adj/Sg$ = {<+NN><Neut><NA><Sg><Wk>}:{}   | \
                 {<+NN><Neut><Dat><Sg><St>}:{m} | \
                 {<+NN><Neut><Gen><Sg><SW>}:{n} | \
                 {<+NN><Neut><Dat><Sg><Wk>}:{n} | \
                 {<+NN><Neut><NA><Sg><St>}:{s}


% pluralia tantum

% Leute
$N?/Pl_0$ = {<+NN><NoGend>}:{} $NPl_0$

% Kosten
$N?/Pl_x$ = {<+NN><NoGend>}:{} $NPl_x$


% proper names

% family names ending in -s, -z
$FamName_0$ = {<+NPROP><NoGend>}:{}    $NSg_0$ | \
              {<+NPROP><NoGend>}:{ens} $NPl_x$

% family names
$FamName_s$ = {<+NPROP><NoGend>}:{}  $NSg_s$ | \
              {<+NPROP><NoGend>}:{s} $NPl_x$

$Name-Fem_0$ = {<+NPROP><Fem>}:{} $NSg_0$

% Felicitas/Felicitas'
$Name-Fem_apos$ = {<+NPROP><Fem>}:{}            $NSg_0$ | \
                  {<+NPROP><Fem><Gen><Sg>}:{’}

$Name-Fem_s$ = {<+NPROP><Fem>}:{} $NSg_s$

$Name-Masc_0$ = {<+NPROP><Masc>}:{} $NSg_0$

% Andreas/Andreas'
$Name-Masc_apos$ = {<+NPROP><Masc>}:{}           $NSg_0$ | \
                   {<+NPROP><Masc><Gen><Sg>}:{’}

$Name-Masc_es$ = {<+NPROP><Masc>}:{} $NSg_es$

$Name-Masc_s$ = {<+NPROP><Masc>}:{} $NSg_s$

$Name-Neut_0$ = {<+NPROP><Neut>}:{} $NSg_0$

% Paris/Paris'
$Name-Neut_apos$ = {<+NPROP><Neut>}:{}            $NSg_0$ | \
                   {<+NPROP><Neut><Gen><Sg>}:{’}

$Name-Neut_es$ = {<+NPROP><Neut>}:{} $NSg_es$

$Name-Neut_s$ = {<+NPROP><Neut>}:{} $NSg_s$

$Name-Pl_0$ = {<+NPROP><NoGend>}:{} $NPl_0$

$Name-Pl_x$ = {<+NPROP><NoGend>}:{} $NPl_x$


% adjectives

$TMP$ = {<Attr/Subst><Fem><NA><Sg><SW>}:{e}      | \
        {<Attr/Subst><Masc><Nom><Sg><Wk>}:{e}    | \
        {<Attr/Subst><Neut><NA><Sg><Wk>}:{e}     | \
        {<Attr/Subst><NoGend><NA><Pl><St>}:{e}   | \
        {<Attr/Subst><MN><Dat><Sg><St>}:{em}     | \
        {<Attr/Subst><Fem><Gen><Sg><Wk>}:{en}    | \
        {<Attr/Subst><MN><Gen><Sg><SW>}:{en}     | \
        {<Attr/Subst><Masc><Acc><Sg><SW>}:{en}   | \
        {<Attr/Subst><MFN><Dat><Sg><Wk>}:{en}    | \
        {<Attr/Subst><NoGend><Dat><Pl><SW>}:{en} | \
        {<Attr/Subst><NoGend><NGA><Pl><Wk>}:{en} | \
        {<Attr/Subst><Fem><GD><Sg><St>}:{er}     | \
        {<Attr/Subst><Masc><Nom><Sg><St>}:{er}   | \
        {<Attr/Subst><NoGend><Gen><Pl><St>}:{er} | \
        {<Attr/Subst><Neut><NA><Sg><St>}:{es}

$AdjInflSuff$ = $TMP$

% lila; klasse
$AdjPos0$ = {<+ADJ><Pos><Pred/Adv>}:{} | \
            {<+ADJ><Pos><Attr><Invar>}:{}

% viel; wenig
$AdjPos0-viel$ = {<+ADJ><Pos><Pred/Adv>}:{} | \
                 {<+ADJ><Pos><Attr/Subst><Invar>}:{}

% innen; feil
$AdjPosPred$ = {<+ADJ><Pos><Pred/Adv>}:{}

% zig
$AdjPos0Attr$ = {<+ADJ><Pos><Attr><Invar>}:{}

% Berliner ('related to Berlin')
$AdjPos0AttrSubst$ = {<+ADJ><Pos><Attr/Subst><Invar>}:{}

% bloß, bloß-; derartig, derartig-
$AdjPos$ = {<+ADJ><Pos><Pred/Adv>}:{<FB>} | \
           {<+ADJ><Pos>}:{<FB>}           $AdjInflSuff$

% ander-; vorig-
$AdjPosAttr$ = {<+ADJ><Pos>}:{<FB>}    $AdjInflSuff$

% besser, besser-; höher, höher-
$AdjComp$ = {<+ADJ><Comp><Pred/Adv>}:{er} | \
            {<+ADJ><Comp>}:{er}           $AdjInflSuff$

% mehr; weniger
$AdjComp0-mehr$ = {<+ADJ><Comp><Pred/Adv>}:{} | \
                  {<+ADJ><Comp><Attr/Subst><Invar>}:{}

% besten, best-; höchsten, höchst-
$AdjSup$ = {<+ADJ><Sup><Pred/Adv>}:{sten} | \
           {<+ADJ><Sup>}:{st}             $AdjInflSuff$

% allerbesten, allerbest-; allerhöchsten, allerhöchst-
$AdjSup-aller$ = {<+ADJ><Sup><Pred/Adv>}:{sten} | \
                 {<+ADJ><Sup>}:{st}             $AdjInflSuff$

% faul-, fauler-, faulst-
$Adj+$ =           $AdjPos$  | \
         {}:{<FB>} $AdjComp$ | \
         {}:{<FB>} $AdjSup$

% bunt, bunter-, buntest-
$Adj+e$ =            $AdjPos$  | \
          {}:{<FB>}  $AdjComp$ | \
          {}:{<FB>e} $AdjSup$

% frei-, freier, frei(e)st-
$Adj+(e)$ =            $AdjPos$  | \
            {}:{<FB>}  $AdjComp$ | \
            {}:{<FB>}  $AdjSup$  | \
            {}:{<FB>e} $AdjSup$

% krass-, krasser-, krassest-; nass-, nasser-, nassest-
$Adj~+e$ = $SS$            $AdjPos$  | \
           $SS$ {}:{<FB>}  $AdjComp$ | \
           $SS$ {}:{<FB>e} $AdjSup$

% warm-, wärmer-, wärmst-
$Adj\$$ =           $AdjPos$  | \
          {}:{<UL>} $AdjComp$ | \
          {}:{<UL>} $AdjSup$

% kalt-, kälter-, kältest-
$Adj\$e$ =            $AdjPos$  | \
           {}:{<UL>}  $AdjComp$ | \
           {}:{<UL>e} $AdjSup$

% nass-, nässer-, nässest-
$Adj~\$e$ = $SS$            $AdjPos$  | \
            $SS$ {}:{<UL>}  $AdjComp$ | \
            $SS$ {}:{<UL>e} $AdjSup$

% dunkel; finster
$Adj-el/er$ = {}:{<^Ax>} $Adj+$

% deutsch; [das] Deutsch
$Adj+Lang$ = $Adj+$ | \
             $NNeut/Sg_s$


% articles and pronouns

$ArtDefAttrSuff$ = {<Attr><Fem><NA><Sg><St>}:{ie}     | \
                   {<Attr><NoGend><NA><Pl><St>}:{ie}  | \
                   {<Attr><MN><Dat><Sg><St>}:{em}     | \
                   {<Attr><Masc><Acc><Sg><St>}:{en}   | \
                   {<Attr><NoGend><Dat><Pl><St>}:{en} | \
                   {<Attr><Fem><GD><Sg><St>}:{er}     | \
                   {<Attr><Masc><Nom><Sg><St>}:{er}   | \
                   {<Attr><NoGend><Gen><Pl><St>}:{er} | \
                   {<Attr><Neut><NA><Sg><St>}:{as}    | \
                   {<Attr><MN><Gen><Sg><St>}:{es}

$ArtDefSubstSuff$ = {<Subst><Fem><NA><Sg><St>}:{ie}       | \
                    {<Subst><NoGend><NA><Pl><St>}:{ie}    | \
                    {<Subst><MN><Dat><Sg><St>}:{em}       | \
                    {<Subst><Masc><Acc><Sg><St>}:{en}     | \
                    {<Subst><NoGend><Dat><Pl><St>}:{enen} | \
                    {<Subst><Fem><Dat><Sg><St>}:{er}      | \
                    {<Subst><Masc><Nom><Sg><St>}:{er}     | \
                    {<Subst><Fem><Gen><Sg><St>}:{eren}    | \
                    {<Subst><NoGend><Gen><Pl><St>}:{eren} | \
                    {<Subst><Fem><Gen><Sg><St>}:{erer}    | \
                    {<Subst><NoGend><Gen><Pl><St>}:{erer} | \
                    {<Subst><Neut><NA><Sg><St>}:{as}      | \
                    {<Subst><MN><Gen><Sg><St>}:{essen}

$ArtDefSuff$ = $ArtDefAttrSuff$ | \
               $ArtDefSubstSuff$

$RelSuff$ = $ArtDefSubstSuff$

$DemDefSuff$ = $ArtDefSuff$

$DemSuff$ = {<AS><Fem><NA><Sg><St>}:{e}           | \
            {<AS><NoGend><NA><Pl><St>}:{e}        | \
            {<AS><MN><Dat><Sg><St>}:{em}          | \
            {<AS><Masc><Acc><Sg><St>}:{en}        | \
            {<Attr><MN><Gen><Sg><St><NonSt>}:{en} | \ % cf. Duden-Grammatik (2016: § 356, 379)
            {<AS><NoGend><Dat><Pl><St>}:{en}      | \
            {<AS><Fem><GD><Sg><St>}:{er}          | \
            {<AS><Masc><Nom><Sg><St>}:{er}        | \
            {<AS><NoGend><Gen><Pl><St>}:{er}      | \
            {<AS><Neut><NA><Sg><St>}:{es}         | \
            {<AS><MN><Gen><Sg><St>}:{es}

$DemSuff-dies$ = $DemSuff$ | \
                 {<AS><Neut><NA><Sg><St>}:{}

$DemSuff-solch/St$ = $DemSuff$

$DemSuff-solch/Wk$ = {<AS><Fem><NA><Sg><Wk>}:{e}      | \
                     {<AS><Masc><Nom><Sg><Wk>}:{e}    | \
                     {<AS><Neut><NA><Sg><Wk>}:{e}     | \
                     {<AS><Fem><Gen><Sg><Wk>}:{en}    | \
                     {<AS><MN><Gen><Sg><Wk>}:{en}     | \
                     {<AS><Masc><Acc><Sg><Wk>}:{en}   | \
                     {<AS><MFN><Dat><Sg><Wk>}:{en}    | \
                     {<AS><NoGend><Dat><Pl><Wk>}:{en} | \
                     {<AS><NoGend><NGA><Pl><Wk>}:{en}

$DemSuff-solch$ = $DemSuff-solch/St$ | \
                  $DemSuff-solch/Wk$ | \ % cf. Duden-Grammatik (2016: § 432)
                  {<Attr><Invar>}:{}

$WSuff-welch$ = $DemSuff-solch/St$ | \
                {<Attr><Invar>}:{}

$RelSuff-welch$ = $WSuff-welch$ % cf. Duden-Grammatik (2016: § 403)

$IndefSuff-welch$ = {<Subst><Fem><NA><Sg><St>}:{e}      | \
                    {<Subst><NoGend><NA><Pl><St>}:{e}   | \
                    {<Subst><MN><Dat><Sg><St>}:{em}     | \
                    {<Subst><Masc><Acc><Sg><St>}:{en}   | \
                    {<Subst><NoGend><Dat><Pl><St>}:{en} | \
                    {<Subst><Fem><GD><Sg><St>}:{er}     | \
                    {<Subst><Masc><Nom><Sg><St>}:{er}   | \
                    {<Subst><NoGend><Gen><Pl><St>}:{er} | \
                    {<Subst><Neut><NA><Sg><St>}:{es}    | \
                    {<Subst><MN><Gen><Sg><St>}:{es}

$IndefSuff-irgendwelch$ = $DemSuff-solch/St$

$IndefSuff-all$ = $DemSuff-solch/St$                     | \
                  {<Subst><MN><Dat><Sg><Wk><NonSt>}:{en} | \ % cf. Duden-Grammatik (2016: § 411)
                  {<Attr><Invar>}:{}

$IndefSuff-jed/St$ = {<AS><Fem><NA><Sg><St>}:{e}           | \
                     {<AS><MN><Dat><Sg><St>}:{em}          | \
                     {<AS><Masc><Acc><Sg><St>}:{en}        | \
                     {<Attr><MN><Gen><Sg><St><NonSt>}:{en} | \ % cf. Duden-Grammatik (2016: § 356, 422)
                     {<AS><Fem><GD><Sg><St>}:{er}          | \
                     {<AS><Masc><Nom><Sg><St>}:{er}        | \
                     {<AS><Neut><NA><Sg><St>}:{es}         | \
                     {<AS><MN><Gen><Sg><St>}:{es}

$IndefSuff-jed/Wk$ = {<AS><Fem><NA><Sg><Wk>}:{e}    | \
                     {<AS><Masc><Nom><Sg><Wk>}:{e}  | \
                     {<AS><Neut><NA><Sg><Wk>}:{e}   | \
                     {<AS><Fem><Gen><Sg><Wk>}:{en}  | \
                     {<AS><MN><Gen><Sg><Wk>}:{en}   | \
                     {<AS><Masc><Acc><Sg><Wk>}:{en} | \
                     {<AS><MFN><Dat><Sg><Wk>}:{en}

$IndefSuff-jed$ = $IndefSuff-jed/St$ | \
                  $IndefSuff-jed/Wk$

$IndefSuff-jeglich$ = $DemSuff$ | \
                      $IndefSuff-jed/Wk$

$IndefSuff-saemtlich$ = $DemSuff-solch/St$ | \
                        $DemSuff-solch/Wk$ | \
                        {<Subst><Invar>}:{}

$IndefSuff-beid$ = {<AS><NoGend><NA><Pl><St>}:{e}    | \
                   {<Subst><Neut><Dat><Sg><St>}:{em} | \
                   {<AS><NoGend><Dat><Pl><St>}:{en}  | \
                   {<AS><NoGend><Gen><Pl><St>}:{er}  | \
                   {<Subst><Neut><NGA><Sg><St>}:{es} | \
                   {<Subst><Neut><NA><Sg><Wk>}:{e}   | \
                   {<Subst><Neut><GD><Sg><Wk>}:{en}  | \
                   {<AS><NoGend><NGDA><Pl><Wk>}:{en}

$IndefSuff-einig$ = $DemSuff$

$IndefSuff-manch$ = $WSuff-welch$

$IndefSuff-mehrer$ = {<AS><NoGend><NA><Pl><St>}:{e}   | \
                     {<AS><NoGend><Dat><Pl><St>}:{en} | \
                     {<AS><NoGend><Gen><Pl><St>}:{er} | \
                     {<AS><Neut><NA><Sg><St>}:{es}

$IndefSuff0$ = {<AS><Invar>}:{}

$ArtIndefAttrSuff$ = {<Attr><Masc><Nom><Sg><NoInfl>}:{} | \
                     {<Attr><Neut><NA><Sg><NoInfl>}:{}  | \
                     {<Attr><Fem><NA><Sg><St>}:{e}      | \
                     {<Attr><MN><Dat><Sg><St>}:{em}     | \
                     {<Attr><Masc><Acc><Sg><St>}:{en}   | \
                     {<Attr><Fem><GD><Sg><St>}:{er}     | \
                     {<Attr><MN><Gen><Sg><St>}:{es}

$ArtIndefSubstSuff$ = {<Subst><Fem><NA><Sg><St>}:{e}    | \
                      {<Subst><MN><Dat><Sg><St>}:{em}   | \
                      {<Subst><Masc><Acc><Sg><St>}:{en} | \
                      {<Subst><Fem><GD><Sg><St>}:{er}   | \
                      {<Subst><Masc><Nom><Sg><St>}:{er} | \
                      {<Subst><Neut><NA><Sg><St>}:{es}  | \
                      {<Subst><MN><Gen><Sg><St>}:{es}   | \
                      {<Subst><Neut><NA><Sg><St>}:{s}

$ArtIndefSuff$ = $ArtIndefAttrSuff$ | \
                 $ArtIndefSubstSuff$

$IndefSuff-ein/St$ = $ArtIndefSubstSuff$

$IndefSuff-ein/Wk$ = {<Subst><Fem><NA><Sg><Wk>}:{e}    | \
                     {<Subst><Masc><Nom><Sg><Wk>}:{e}  | \
                     {<Subst><Neut><NA><Sg><Wk>}:{e}   | \
                     {<Subst><Fem><Gen><Sg><Wk>}:{en}  | \
                     {<Subst><MN><Gen><Sg><Wk>}:{en}   | \
                     {<Subst><Masc><Acc><Sg><Wk>}:{en} | \
                     {<Subst><MFN><Dat><Sg><Wk>}:{en}

$IndefSuff-ein$ = $IndefSuff-ein/St$ | \
                  $IndefSuff-ein/Wk$

$ArtNegAttrSuff$ = $ArtIndefAttrSuff$                    | \
                   {<Attr><NoGend><NA><Pl><St>}:{e}      | \
                   {<Attr><MN><Gen><Sg><St><NonSt>}:{en} | \ % cf. Duden-Grammatik (2016: § 356, 425)
                   {<Attr><NoGend><Dat><Pl><St>}:{en}    | \
                   {<Attr><NoGend><Gen><Pl><St>}:{er}

$ArtNegSubstSuff$ = $ArtIndefSubstSuff$                 | \
                    {<Subst><NoGend><NA><Pl><St>}:{e}   | \
                    {<Subst><NoGend><Dat><Pl><St>}:{en} | \
                    {<Subst><NoGend><Gen><Pl><St>}:{er}

$ArtNegSuff$ =  $ArtNegAttrSuff$ | \
                $ArtNegSubstSuff$

$IndefSuff-kein$ = $ArtNegSubstSuff$

$PossSuff/St$ = $ArtNegSuff$

$PossSuff/Wk$ = {<Subst><Fem><NA><Sg><Wk>}:{e}      | \
                {<Subst><Masc><Nom><Sg><Wk>}:{e}    | \
                {<Subst><Neut><NA><Sg><Wk>}:{e}     | \
                {<Subst><Fem><Gen><Sg><Wk>}:{en}    | \
                {<Subst><MN><Gen><Sg><Wk>}:{en}     | \
                {<Subst><Masc><Acc><Sg><Wk>}:{en}   | \
                {<Subst><MFN><Dat><Sg><Wk>}:{en}    | \
                {<Subst><NoGend><Dat><Pl><Wk>}:{en} | \
                {<Subst><NoGend><NGA><Pl><Wk>}:{en}

$PossSuff$ = $PossSuff/St$ | \
             $PossSuff/Wk$

$IProSuff0$ = {<Invar>}:{}

$IProSuff$ = {<NDA><Sg>}:{}   | \
             {<Acc><Sg>}:{en} | \
             {<Dat><Sg>}:{em} | \
             {<Gen><Sg>}:{es}

$IProSuff-jedermann$ = {<NDA><Sg>}:{} | \
                       {<Gen><Sg>}:{s}

$IProSuff-man$ = {<Nom><Sg>}:{}

$PProNomSgSuff$ = {<Nom><Sg>}:{}

$PProAccSgSuff$ = {<Acc><Sg>}:{}

$PProDatSgSuff$ = {<Dat><Sg>}:{}

$PProGenSgSuff$ = {<Gen><Sg>}:{er} | \
                  {<Gen><Sg><Old>}:{} % cf. Duden-Grammatik (2016: § 363)

$PProNomPlSuff$ = {<Nom><Pl>}:{}

$PProAccPlSuff$ = {<Acc><Pl>}:{}

$PProDatPlSuff$ = {<Dat><Pl>}:{}

$PProGenPlSuff$ = {<Gen><Pl>}:{er} | \
                  {<Gen><Pl><Old>}:{} % cf. Duden-Grammatik (2016: § 363)

$PProGenPlSuff-er$ = {<Gen><Pl>}:{er} | \
                     {<Gen><Pl><NonSt>}:{er<^Px><FB>er} % cf. Duden-Grammatik (2016: § 363)

$WProNomSgSuff$ = $PProNomSgSuff$

$WProAccSgSuff$ = $PProAccSgSuff$

$WProDatSgSuff$ = $PProDatSgSuff$

$WProGenSgSuff$ = {<Gen><Sg>}:{sen} | \
                  {<Gen><Sg><Old>}:{} % cf. Duden-Grammatik (2016: § 404)

$IProNomSgSuff$ = $WProNomSgSuff$

$IProAccSgSuff$ = $WProAccSgSuff$

$IProDatSgSuff$ = $WProDatSgSuff$

$IProGenSgSuff$ = {<Gen><Sg>}:{sen}

% der, die, das (article)
$ArtDef$ = {<+ART><Def>}:{<FB>} $ArtDefSuff$

% der, die, das (relative pronoun)
$Rel$ = {<+REL>}:{<FB>} $RelSuff$

% der, die, das (demonstrative pronoun)
$DemDef$ = {<+DEM>}:{<FB>} $DemDefSuff$

% dieser, diese, dieses/dies
$Dem-dies$ = {<+DEM>}:{<FB>} $DemSuff-dies$

% solcher, solche, solches, solch
$Dem-solch$ = {<+DEM>}:{<FB>} $DemSuff-solch$

% jener, jene, jenes
$Dem$ = {<+DEM>}:{<FB>} $DemSuff$

% welcher, welche, welches, welch (interrogative pronoun)
$W-welch$ = {<+WPRO>}:{<FB>} $WSuff-welch$

% welcher, welche, welches, welch (relative pronoun)
$Rel-welch$ = {<+REL>}:{<FB>} $RelSuff-welch$

% welcher, welche, welches (indefinite pronoun)
$Indef-welch$ = {<+INDEF>}:{<FB>} $IndefSuff-welch$

% irgendwelcher, irgendwelche, irgendwelches (indefinite pronoun)
$Indef-irgendwelch$ = {<+INDEF>}:{<FB>} $IndefSuff-irgendwelch$

% aller, alle, alles
$Indef-all$ = {<+INDEF>}:{<FB>} $IndefSuff-all$

% jeder, jede, jedes
$Indef-jed$ = {<+INDEF>}:{<FB>} $IndefSuff-jed$

% jeglicher, jegliche, jegliches
$Indef-jeglich$ = {<+INDEF>}:{<FB>} $IndefSuff-jeglich$

% sämtlicher, sämtliche, sämtliches
$Indef-saemtlich$ = {<+INDEF>}:{<FB>} $IndefSuff-saemtlich$

% beide, beides
$Indef-beid$ = {<+INDEF>}:{<FB>} $IndefSuff-beid$

% einiger, einige, einiges
$Indef-einig$ = {<+INDEF>}:{<FB>} $IndefSuff-einig$

% mancher, manche, manches, manch
$Indef-manch$ = {<+INDEF>}:{<FB>} $IndefSuff-manch$

% mehrere, mehreres
$Indef-mehrer$ = {<+INDEF>}:{<FB>} $IndefSuff-mehrer$

% genug
$Indef0$ = {<+INDEF>}:{<FB>} $IndefSuff0$

% ein, eine (article)
$ArtIndef$ = {<+ART><Indef>}:{<FB>} $ArtIndefSuff$

% 'n, 'ne (clitic article)
$ArtIndef-n$ = {<+ART><Indef>}:{<FB>} $ArtIndefAttrSuff$ {<NonSt>}:{} % cf. Duden-Grammatik (2016: § 448)

% einer, eine, eines (indefinite pronoun)
$Indef-ein$ = {<+INDEF>}:{<FB>} $IndefSuff-ein$

% irgendein, irgendeine
$Indef-irgendein$ = {<+INDEF>}:{<FB>} $ArtIndefSuff$

% kein, keine (article)
$ArtNeg$ = {<+ART><Neg>}:{<FB>} $ArtNegSuff$

% keiner, keine, keines (indefinite pronoun)
$Indef-kein$ = {<+INDEF>}:{<FB>} $IndefSuff-kein$

% mein, meine
$Poss$ = {<+POSS>}:{<FB>} $PossSuff$

% unser, unsere/unsre
$Poss-er$ = {<+POSS>}:{<^Px><FB>} $PossSuff$

% (die) meinigen/Meinigen
$Poss/Wk$ = {<+POSS>}:{<FB>} $PossSuff/Wk$

% unserige/unsrige
$Poss/Wk-er$ = {<+POSS>}:{<^Px><FB>} $PossSuff/Wk$

% etwas
$IProNeut$ = {<+INDEF><Neut>}:{<FB>} $IProSuff0$

% jemand
$IProMasc$ = {<+INDEF><Masc>}:{<FB>} $IProSuff$

% jedermann
$IPro-jedermann$ = {<+INDEF><Masc>}:{<FB>} $IProSuff-jedermann$

% man
$IPro-man$ = {<+INDEF><Masc>}:{<FB>} $IProSuff-man$

% ich
$PPro1NomSg$ = {<+PPRO><Pers><1>}:{<FB>} $PProNomSgSuff$

% mich (irreflexive)
$PPro1AccSg$ = {<+PPRO><Pers><1>}:{<FB>} $PProAccSgSuff$

% mir (irreflexive)
$PPro1DatSg$ = {<+PPRO><Pers><1>}:{<FB>} $PProDatSgSuff$

% meiner, mein
$PPro1GenSg$ = {<+PPRO><Pers><1>}:{<FB>} $PProGenSgSuff$

% du
$PPro2NomSg$ = {<+PPRO><Pers><2>}:{<FB>} $PProNomSgSuff$

% dich (irreflexive)
$PPro2AccSg$ = {<+PPRO><Pers><2>}:{<FB>} $PProAccSgSuff$

% dir (irreflexive)
$PPro2DatSg$ = {<+PPRO><Pers><2>}:{<FB>} $PProDatSgSuff$

% deiner, dein
$PPro2GenSg$ = {<+PPRO><Pers><2>}:{<FB>} $PProGenSgSuff$

% sie (singular)
$PProFemNomSg$ = {<+PPRO><Pers><3><Fem>}:{<FB>} $PProNomSgSuff$

% sie (singular)
$PProFemAccSg$ = {<+PPRO><Pers><3><Fem>}:{<FB>} $PProAccSgSuff$

% ihr
$PProFemDatSg$ = {<+PPRO><Pers><3><Fem>}:{<FB>} $PProDatSgSuff$

% ihrer, ihr
$PProFemGenSg$ = {<+PPRO><Pers><3><Fem>}:{<FB>} $PProGenSgSuff$

% er
$PProMascNomSg$ = {<+PPRO><Pers><3><Masc>}:{<FB>} $PProNomSgSuff$

% ihn
$PProMascAccSg$ = {<+PPRO><Pers><3><Masc>}:{<FB>} $PProAccSgSuff$

% ihm
$PProMascDatSg$ = {<+PPRO><Pers><3><Masc>}:{<FB>} $PProDatSgSuff$

% seiner, sein
$PProMascGenSg$ = {<+PPRO><Pers><3><Masc>}:{<FB>} $PProGenSgSuff$

% es
$PProNeutNomSg$ = {<+PPRO><Pers><3><Neut>}:{<FB>} $PProNomSgSuff$

% 's (clitic pronoun)
$PProNeutNomSg-s$ = $PProNeutNomSg$ {<NonSt>}:{}

% es
$PProNeutAccSg$ = {<+PPRO><Pers><3><Neut>}:{<FB>} $PProAccSgSuff$

% 's (clitic pronoun)
$PProNeutAccSg-s$ = $PProNeutAccSg$ {<NonSt>}:{}

% ihm
$PProNeutDatSg$ = {<+PPRO><Pers><3><Neut>}:{<FB>} $PProDatSgSuff$

% seiner
$PProNeutGenSg$ = {<+PPRO><Pers><3><Neut>}:{<FB>} $PProGenSgSuff$

% wir
$PPro1NomPl$ = {<+PPRO><Pers><1>}:{<FB>} $PProNomPlSuff$

% uns (irreflexive)
$PPro1AccPl$ = {<+PPRO><Pers><1>}:{<FB>} $PProAccPlSuff$

% uns (irreflexive)
$PPro1DatPl$ = {<+PPRO><Pers><1>}:{<FB>} $PProDatPlSuff$

% unser, unserer/unsrer
$PPro1GenPl$ = {<+PPRO><Pers><1>}:{<FB>} $PProGenPlSuff-er$

% ihr
$PPro2NomPl$ = {<+PPRO><Pers><2>}:{<FB>} $PProNomPlSuff$

% euch (irreflexive)
$PPro2AccPl$ = {<+PPRO><Pers><2>}:{<FB>} $PProAccPlSuff$

% euch (irreflexive)
$PPro2DatPl$ = {<+PPRO><Pers><2>}:{<FB>} $PProDatPlSuff$

% euer, eurer
$PPro2GenPl$ = {<+PPRO><Pers><2>}:{<FB>} $PProGenPlSuff-er$

% sie (plural)
$PProNoGendNomPl$ = {<+PPRO><Pers><3><NoGend>}:{<FB>} $PProNomPlSuff$

% sie (plural)
$PProNoGendAccPl$ = {<+PPRO><Pers><3><NoGend>}:{<FB>} $PProAccPlSuff$

% ihr
$PProNoGendDatPl$ = {<+PPRO><Pers><3><NoGend>}:{<FB>} $PProDatPlSuff$

% ihrer, ihr
$PProNoGendGenPl$ = {<+PPRO><Pers><3><NoGend>}:{<FB>} $PProGenPlSuff$

% mich (reflexive)
$PRefl1AccSg$ = {<+PPRO><Refl><1>}:{<FB>} $PProAccSgSuff$

% mir (reflexive)
$PRefl1DatSg$ = {<+PPRO><Refl><1>}:{<FB>} $PProDatSgSuff$

% dich (reflexive)
$PRefl2AccSg$ = {<+PPRO><Refl><2>}:{<FB>} $PProAccSgSuff$

% dir (reflexive)
$PRefl2DatSg$ = {<+PPRO><Refl><2>}:{<FB>} $PProDatSgSuff$

% uns (reflexive)
$PRefl1Pl$ = {<+PPRO><Refl><1>}:{<FB>} $PProAccPlSuff$ | \
             {<+PPRO><Refl><1>}:{<FB>} $PProDatPlSuff$

% euch (reflexive)
$PRefl2Pl$ = {<+PPRO><Refl><2>}:{<FB>} $PProAccPlSuff$ | \
             {<+PPRO><Refl><2>}:{<FB>} $PProDatPlSuff$

% sich
$PRefl3$ = {<+PPRO><Refl><3>}:{<FB>} $PProAccSgSuff$ | \
           {<+PPRO><Refl><3>}:{<FB>} $PProDatSgSuff$ | \
           {<+PPRO><Refl><3>}:{<FB>} $PProAccPlSuff$ | \
           {<+PPRO><Refl><3>}:{<FB>} $PProDatPlSuff$

% wer (interrogative pronoun)
$WProMascNomSg$ = {<+WPRO><Masc>}:{<FB>} $WProNomSgSuff$

% wen (interrogative pronoun)
$WProMascAccSg$ = {<+WPRO><Masc>}:{<FB>} $WProAccSgSuff$

% wem (interrogative pronoun)
$WProMascDatSg$ = {<+WPRO><Masc>}:{<FB>} $WProDatSgSuff$

% wessen, wes (interrogative pronoun)
$WProMascGenSg$ = {<+WPRO><Masc>}:{<FB>} $WProGenSgSuff$

% was (interrogative pronoun)
$WProNeutNomSg$ = {<+WPRO><Neut>}:{<FB>} $WProNomSgSuff$

% was (interrogative pronoun)
$WProNeutAccSg$ = {<+WPRO><Neut>}:{<FB>} $WProAccSgSuff$

% was (interrogative pronoun)
$WProNeutDatSg$ = {<+WPRO><Neut>}:{<FB>} $WProDatSgSuff$ {<NonSt>}:{} % cf. Duden-Grammatik (2016: § 404)

% wessen, wes (interrogative pronoun)
$WProNeutGenSg$ = {<+WPRO><Neut>}:{<FB>} $WProGenSgSuff$

% wer (indefinite pronoun)
$IProMascNomSg$ = {<+INDEF><Masc>}:{<FB>} $IProNomSgSuff$

% wen (indefinite pronoun)
$IProMascAccSg$ = {<+INDEF><Masc>}:{<FB>} $IProAccSgSuff$

% wem (indefinite pronoun)
$IProMascDatSg$ = {<+INDEF><Masc>}:{<FB>} $IProDatSgSuff$

% wessen (indefinite pronoun)
$IProMascGenSg$ = {<+INDEF><Masc>}:{<FB>} $IProGenSgSuff$

% was (indefinite pronoun)
$IProNeutNomSg$ = {<+INDEF><Neut>}:{<FB>} $IProNomSgSuff$

% was (indefinite pronoun)
$IProNeutAccSg$ = {<+INDEF><Neut>}:{<FB>} $IProAccSgSuff$

% was (indefinite pronoun)
$IProNeutDatSg$ = {<+INDEF><Neut>}:{<FB>} $IProDatSgSuff$ {<NonSt>}:{}

% wessen (indefinite pronoun)
$IProNeutGenSg$ = {<+INDEF><Neut>}:{<FB>} $IProGenSgSuff$


% numerals

$CardSuff0$ = {<AS><Invar>}:{}

$CardSuff-ein/St$ = $ArtIndefSuff$

$CardSuff-ein/Wk$ = {<AS><Fem><NA><Sg><Wk>}:{e}    | \
                    {<AS><Masc><Nom><Sg><Wk>}:{e}  | \
                    {<AS><Neut><NA><Sg><Wk>}:{e}   | \
                    {<AS><Fem><Gen><Sg><Wk>}:{en}  | \
                    {<AS><MN><Gen><Sg><Wk>}:{en}   | \
                    {<AS><Masc><Acc><Sg><Wk>}:{en} | \
                    {<AS><MFN><Dat><Sg><Wk>}:{en}

$CardSuff-ein$ = $CardSuff-ein/St$ | \
                 $CardSuff-ein/Wk$

$CardSuff-kein$ = $ArtNegSuff$

$CardSuff-zwei$ = $CardSuff0$                              | \
                  {<Subst><NoGend><NA><Pl><SW><NonSt>}:{e} | \ % cf. Duden-Grammatik (2016: § 511)
                  {<Subst><NoGend><Dat><Pl><SW>}:{en}      | \ % cf. Duden-Grammatik (2016: § 511)
                  {<AS><NoGend><Gen><Pl><St>}:{er}             % cf. Duden-Grammatik (2016: § 511)

$CardSuff-vier$ = $CardSuff0$                              | \
                  {<Subst><NoGend><NA><Pl><SW><NonSt>}:{e} | \ % cf. Duden-Grammatik (2016: § 511)
                  {<Subst><NoGend><Dat><Pl><SW>}:{en}          % cf. Duden-Grammatik (2016: § 511)

$CardSuff-sieben$ = $CardSuff0$ | \
                    {<Subst><NoGend><NA><Pl><SW><NonSt>}:{e} % cf. Duden-Grammatik (2016: § 511)

% ein, eine (cardinal)
$Card-ein$ = {<+CARD>}:{<FB>} $CardSuff-ein$

% kein, keine (cardinal)
$Card-kein$ = {<+CARD>}:{<FB>} $CardSuff-kein$

% zwei, zweien, zweier; drei, dreien, dreier
$Card-zwei$ = {<+CARD>}:{<FB>} $CardSuff-zwei$

% vier, vieren; zwölf, zwölfen
$Card-vier$ = {<+CARD>}:{<FB>} $CardSuff-vier$

% sieben
$Card-sieben$ = {<+CARD>}:{<FB>} $CardSuff-sieben$

% null; zwo; dreizehn; zwanzig; hundert
$Card0$ = <+CARD>:<> $CardSuff0$

% erst-
$Ord$ = {<+ORD>}:{<FB>} $AdjInflSuff$

% 1
$DigCard$ = {<+CARD><Invar>}:{}

% 1.
$DigOrd$ = {<+ORD><Invar>}:{}

% 1,5
$DigFrac$ = {<+FRAC><Invar>}:{}

% I
$Roman$ = {<+CARD><Invar>}:{}


% adverbs

% oft; gern; sehr
$Adv$ = {<+ADV>}:{}

% mehr
$AdvComp0$ = {<+ADV><Comp>}:{}

% öfter; lieber;
$AdvComp$ = {<+ADV><Comp>}:{er}

% öftesten; liebsten; meisten
$AdvSup$ = {<+ADV><Sup>}:{sten}


% verbs

% sei; hab/habe; werde; tu
$VAImpSg$ = {<+V><Imp><Sg>}:{<^imp>}

% seid; habt; werdet; tut
$VAImpPl$ = {<+V><Imp><Pl>}:{<^imp>}

% bin; habe; werde; tue
$VAPres1SgInd$ = {<+V><1><Sg><Pres><Ind>}:{}

% bist; hast; wirst; tust
$VAPres2SgInd$ = {<+V><2><Sg><Pres><Ind>}:{}

% ist; hat; wird; tut
$VAPres3SgInd$ = {<+V><3><Sg><Pres><Ind>}:{}

% sind; haben; werden; tun
$VAPres1/3PlInd$ = {<+V><13><Pl><Pres><Ind>}:{}

% seid; habt; werdet; tut
$VAPres2PlInd$ = {<+V><2><Pl><Pres><Ind>}:{}

% sei; habe; werde; tue
$VAPres1/3SgKonj$ = {<+V><13><Sg><Pres><Subj>}:{<FB>}

% sei-st, seie-st; habe-st; werde-st; tue-st
$VAPres2SgKonj$ = {<+V><2><Sg><Pres><Subj>}:{<FB>st}

$VAPresKonjSg$ = {<+V><13><Sg><Pres><Subj>}:{<FB>} | \
                 {<+V><2><Sg><Pres><Subj>}:{<FB>st}

$VAPresKonjPl$ = {<+V><13><Pl><Pres><Subj>}:{<FB>n} | \
                 {<+V><2><Pl><Pres><Subj>}:{<FB>t}

% ward, wardst
$VAPastIndSg$ = {<+V><13><Sg><Past><Ind>}:{<FB>} | \
                {<+V><2><Sg><Past><Ind>}:{<FB>st}

% wurden, wurdet
$VAPastIndPl$ = {<+V><13><Pl><Past><Ind>}:{<FB>en} | \
                {<+V><2><Pl><Past><Ind>}:{<INS-E>t}

$VAPastKonj2$ = {<+V><2><Sg><Past><Subj>}:{<FB>st} | \
                {<+V><2><Pl><Past><Subj>}:{<FB>t}

$haben$ = {<haben>}:{}

$sein$ = {<sein>}:{}

$VPPres$ = {<+V><PPres>}:{} | \
           {<+V><PPres><zu>}:{<^zz>}

$VPPast$ = {<+V><PPast>}:{<^pp>}

$VPPast+haben$ = $VPPast$ $haben$

$VPPast+sein$ = $VPPast$ $sein$

$VPP-en$ = {}:{<FB>en} $VPPast$

$VPP-t$ =  {}:{<INS-E>t} $VPPast$

$VInf$ = {<+V><Inf>}:{} | \
         {<+V><Inf><zu>}:{<^zz>}

$VInf+PPres$ =        $VInf$ | \
               {}:{d} $VPPres$

$VInfStem$ = {}:{<FB>en} $VInf+PPres$

% sein, seiend; tun, tuend
$VInfStem-n$ = {}:{<FB>n}   $VInf$ | \
               {}:{<FB>end} $VPPres$

$VInf-en$ =    $VInfStem$

$VInf-n$ =     $VInfStem-n$

% kommt, schaut, arbeit-e-t
$VImpPl$ = {<+V><Imp><Pl>}:{<INS-E>t<^imp>}

% komm, schau, arbeit-e
$VImpSg$ = {<+V><Imp><Sg>}:{<INS-E><^imp>}

% flicht
$VImpSg0$ = {<+V><Imp><Sg>}:{<^imp>}

% (ich) will, bedarf
$VPres1Irreg$ = {<+V><1><Sg><Pres><Ind>}:{<FB>}

% (ich) liebe, rate, sammle
$VPres1Reg$ = {<+V><1><Sg><Pres><Ind>}:{<FB>e}

% (du) hilfst, rätst
$VPres2Irreg$ = {<+V><2><Sg><Pres><Ind>}:{<FB>st}

% (du) liebst, biet-e-st, sammelst
$VPres2Reg$ = {<+V><2><Sg><Pres><Ind>}:{<INS-E>st}

% (er) rät, will
$VPres3Irreg$ = {<+V><3><Sg><Pres><Ind>}:{<FB>}

% (er) liebt, hilft, sammelt
$VPres3Reg$ = {<+V><3><Sg><Pres><Ind>}:{<INS-E>t}

% (wir) lieben, wollen, sammeln
$VPresPlInd$ = {<+V><13><Pl><Pres><Ind>}:{<FB>en} | \
% (ihr) liebt, biet-e-t, sammelt
               {<+V><2><Pl><Pres><Ind>}:{<INS-E>t}

% (ich) liebe, wolle, sammle
$VPresKonj$ = {<+V><13><Sg><Pres><Subj>}:{<FB>e}  | \
% (du) liebest, wollest, sammelst
              {<+V><2><Sg><Pres><Subj>}:{<FB>est} | \
% (wir) lieben, wollen, sammeln
              {<+V><13><Pl><Pres><Subj>}:{<FB>en} | \
% (ihr) liebet, wollet, sammelt
              {<+V><2><Pl><Pres><Subj>}:{<FB>et}

% (ich) liebte, wollte, arbeit-e-te
$VPastIndReg$ = {<+V><13><Sg><Past><Ind>}:{<INS-E>te}  | \
% (ich) brachte
                {<+V><2><Sg><Past><Ind>}:{<INS-E>test} | \
                {<+V><13><Pl><Past><Ind>}:{<INS-E>ten} | \
                {<+V><2><Pl><Past><Ind>}:{<INS-E>tet}

% (ich) wurde
$VPastIndIrreg$ = {<+V><13><Sg><Past><Ind>}:{<FB>e}  | \
                  {<+V><2><Sg><Past><Ind>}:{<FB>est} | \
                  {<+V><13><Pl><Past><Ind>}:{<FB>en} | \
                  {<+V><2><Pl><Past><Ind>}:{<FB>et}

% (ich) fuhr, ritt, fand
$VPastIndStr$ = {<+V><13><Sg><Past><Ind>}:{<FB>}     | \
% (du) fuhrst, ritt-e-st, fand-e-st
                {<+V><2><Sg><Past><Ind>}:{<INS-E>st} | \
                {<+V><13><Pl><Past><Ind>}:{<FB>en}   | \
                {<+V><2><Pl><Past><Ind>}:{<INS-E>t}

% (ich) liebte, wollte, arbeit-e-te
$VPastKonjReg$ = {<+V><13><Sg><Past><Subj>}:{<INS-E>te}  | \
% (ich) brächte
                 {<+V><2><Sg><Past><Subj>}:{<INS-E>test} | \
                 {<+V><13><Pl><Past><Subj>}:{<INS-E>ten} | \
                 {<+V><2><Pl><Past><Subj>}:{<INS-E>tet}

% (ich) führe, ritte, fände
$VPastKonjStr$ = {<+V><13><Sg><Past><Subj>}:{<FB>e}  | \
                 {<+V><2><Sg><Past><Subj>}:{<FB>est} | \
                 {<+V><13><Pl><Past><Subj>}:{<FB>en} | \
                 {<+V><2><Pl><Past><Subj>}:{<FB>et}

$VInflPres2$ = $VPres2Irreg$ | \
               $VPres3Reg$

$VInflPres2t$ = $VPres2Irreg$ | \
                $VPres3Irreg$

$VInflPres1$ = $VPres1Reg$  | \
               $VPresPlInd$ | \
               $VPresKonj$  | \
               $VImpPl$

$VInflPresReg$ = $VInflPres1$ | \
                 $VPres2Reg$  | \
                 $VPres3Reg$  | \
                 $VImpSg$

$VInflReg$ =  $VInflPresReg$ | \
              $VPastIndReg$  | \
              $VPastKonjReg$

$VModInflSg$ = $VPres1Irreg$ | \
               $VPres2Reg$   | \
               $VPres3Irreg$

$VModInflPl$ = $VPresPlInd$ | \
               $VPresKonj$

$VVPres$ = $VInflPresReg$ | \
           $VInfStem$

$VVPres1$ = $VInflPres1$ | \
            $VInfStem$

$VVPres1+Imp$ = $VImpSg$ | \
                $VVPres1$

$VVPres2$ = $VInflPres2$

$VVPres2t$ = $VInflPres2t$

$VVPres2+Imp$ = $VImpSg$ | \
                $VVPres2$

$VVPres2+Imp0$ = $VImpSg0$ | \
                 $VVPres2t$

% bedarf-; weiss-
$VVPresSg$ = $VModInflSg$

% bedürf-, wiss-
$VVPresPl$ = $VModInflPl$ | \
             $VInfStem$

$VVPastIndReg$ = $VPastIndReg$

$VVPastIndStr$ = $VPastIndStr$

$VVPastKonjReg$ = $VPastKonjReg$

$VVPastKonjStr$ = $VPastKonjStr$

$VVPastStr$ = $VVPastIndStr$ | \
              $VVPastKonjStr$

$VVRegFin$ = $VInflReg$

$VVReg$ = $VInflReg$ | \
          $VPP-t$    | \
          $VInfStem$

$VVReg+haben$ = $VInflReg$ | \
                $VPP-t$ $haben$ | \
                $VInfStem$

$VVReg+sein$ = $VInflReg$ | \
               $VPP-t$ $sein$ | \
               $VInfStem$

$VVReg-el/er$ = $VVReg$

$VVReg-el/er+haben$ = $VVReg+haben$

$VVReg-el/er+sein$ = $VVReg+sein$

$VMPastKonj$ = $VPastKonjReg$

$VMPresSg$ = $VModInflSg$

$VMPresPl$ = $VModInflPl$ | \
             $VInfStem$

$VMPast$ = $VPastIndReg$ | \
           $VPP-t$

$VMPast+haben$ = $VPastIndReg$ | \
                 $VPP-t$ $haben$

$VMPast+sein$ = $VPastIndReg$ | \
                $VPP-t$ $sein$

$VVPP-en$ = $VPP-en$

$VVPP-en+haben$ = $VPP-en$ $haben$

$VVPP-en+sein$ = $VPP-en$ $sein$

$VVPP-t$ = $VPP-t$

$VVPP-t+haben$ = $VPP-t$ $haben$

$VVPP-t+sein$ = $VPP-t$ $sein$


% adpositions

$Postp-Akk$ = {<+POSTP><Acc>}:{}

$Postp-Dat$ = {<+POSTP><Dat>}:{}

$Postp-Gen$ = {<+POSTP><Gen>}:{}

$Prep-Akk$ = {<+PREP><Acc>}:{}

$Prep-Dat$ = {<+PREP><Dat>}:{}

$Prep-Gen$ = {<+PREP><Gen>}:{}

$Prep-GDA$ = {<+PREP><GDA>}:{}

$Prep-DA$ = {<+PREP><DA>}:{}

$Prep-GD$ = {<+PREP><GD>}:{}

$Prep/Art-m$ = {<+PREPART><MN><Dat><Sg>}:{}

% untern (Tisch)
$Prep/Art-n$ = {<+PREPART><Masc><Acc><Sg>}:{}

$Prep/Art-r$ = {<+PREPART><Fem><Dat><Sg>}:{}

$Prep/Art-s$ = {<+PREPART><Neut><Acc><Sg>}:{}

$Circp$ = {<+CIRCP>}:{}


% abbreviations

% Ew. (= Euer)
$Abk_POSS$ = {<+POSS><Attr><Invar>}:{}


% other words

$Intj$ = {<+INTJ>}:{}

$Konj-Inf$ = {<+CONJ><Inf>}:{}

$Konj-Kon$ = {<+CONJ><Coord>}:{}

$Konj-Sub$ = {<+CONJ><Sub>}:{}

$Konj-Vgl$ = {<+CONJ><Compar>}:{}

$PInd-Invar$ = {<+INDEF><Invar>}:{}

$ProAdv$ = {<+PROADV>}:{}

$Ptkl-Adj$ = {<+PTCL><Adj>}:{}

$Ptkl-Ant$ = {<+PTCL><Ant>}:{}

$Ptkl-Neg$ = {<+PTCL><Neg>}:{}

$Ptkl-Zu$ = {<+PTCL><zu>}:{}

$WAdv$ = {<+WADV>}:{}

$Trunc$ = {<+TRUNC>}:{}

$NTrunc$ = {<+TRUNC>}:{}

$Pref/Adv$ = {<+VPART><Adv>}:{}

$Pref/Adj$ = {<+VPART><Adj>}:{}

$Pref/ProAdv$ = {<+VPART><ProAdv>}:{}

$Pref/N$ = {<+VPART><NN>}:{}

$Pref/V$ = {<+VPART><V>}:{}

$Pref/Sep$ = {<+VPART>}:{}


% inflection transducer

$INFL$ = <>:<Abk_POSS>              $Abk_POSS$          | \
         <>:<Adj$>                  $Adj\$$             | \
         <>:<Adj$e>                 $Adj\$e$            | \
         <>:<Adj+>                  $Adj+$              | \
         <>:<Adj+(e)>               $Adj+(e)$           | \
         <>:<Adj+e>                 $Adj+e$             | \
         <>:<Adj+Lang>              $Adj+Lang$          | \
         <>:<Adj-el/er>             $Adj-el/er$         | \
         <>:<AdjComp>               $AdjComp$           | \
         <>:<AdjComp0-mehr>         $AdjComp0-mehr$     | \
         <>:<AdjPos0>               $AdjPos0$           | \
         <>:<AdjPos0-viel>          $AdjPos0-viel$      | \
         <>:<AdjPos0Attr>           $AdjPos0Attr$       | \
         <>:<AdjPos0AttrSubst>      $AdjPos0AttrSubst$  | \
         <>:<AdjPos>                $AdjPos$            | \
         <>:<AdjPosAttr>            $AdjPosAttr$        | \
         <>:<AdjPosPred>            $AdjPosPred$        | \
         <>:<AdjSup>                $AdjSup$            | \
         <>:<AdjSup-aller>          $AdjSup-aller$      | \
         <>:<Adj~$e>                $Adj~\$e$           | \
         <>:<Adj~+e>                $Adj~+e$            | \
         <>:<Adv>                   $Adv$               | \
         <>:<AdvComp>               $AdvComp$           | \
         <>:<AdvComp0>              $AdvComp0$          | \
         <>:<AdvSup>                $AdvSup$            | \
         <>:<ArtDef>                $ArtDef$            | \
         <>:<ArtIndef>              $ArtIndef$          | \
         <>:<ArtIndef-n>            $ArtIndef-n$        | \
         <>:<ArtNeg>                $ArtNeg$            | \
         <>:<Card0>                 $Card0$             | \
         <>:<Card-ein>              $Card-ein$          | \
         <>:<Card-kein>             $Card-kein$         | \
         <>:<Card-sieben>           $Card-sieben$       | \
         <>:<Card-vier>             $Card-vier$         | \
         <>:<Card-zwei>             $Card-zwei$         | \
         <>:<Circp>                 $Circp$             | \
         <>:<Dem>                   $Dem$               | \
         <>:<Dem-dies>              $Dem-dies$          | \
         <>:<Dem-solch>             $Dem-solch$         | \
         <>:<DemDef>                $DemDef$            | \
         <>:<DigCard>               $DigCard$           | \
         <>:<DigFrac>               $DigFrac$           | \
         <>:<DigOrd>                $DigOrd$            | \
         <>:<FamName_0>             $FamName_0$         | \
         <>:<FamName_s>             $FamName_s$         | \
         <>:<Indef0>                $Indef0$            | \
         <>:<Indef-all>             $Indef-all$         | \
         <>:<Indef-beid>            $Indef-beid$        | \
         <>:<Indef-ein>             $Indef-ein$         | \
         <>:<Indef-einig>           $Indef-einig$       | \
         <>:<Indef-irgendein>       $Indef-irgendein$   | \
         <>:<Indef-irgendwelch>     $Indef-irgendwelch$ | \
         <>:<Indef-jed>             $Indef-jed$         | \
         <>:<Indef-jeglich>         $Indef-jeglich$     | \
         <>:<Indef-kein>            $Indef-kein$        | \
         <>:<Indef-manch>           $Indef-manch$       | \
         <>:<Indef-mehrer>          $Indef-mehrer$      | \
         <>:<Indef-saemtlich>       $Indef-saemtlich$   | \
         <>:<Indef-welch>           $Indef-welch$       | \
         <>:<IPro-jedermann>        $IPro-jedermann$    | \
         <>:<IPro-man>              $IPro-man$          | \
         <>:<IProMasc>              $IProMasc$          | \
         <>:<IProMascAccSg>         $IProMascAccSg$     | \
         <>:<IProMascDatSg>         $IProMascDatSg$     | \
         <>:<IProMascGenSg>         $IProMascGenSg$     | \
         <>:<IProMascNomSg>         $IProMascNomSg$     | \
         <>:<IProNeut>              $IProNeut$          | \
         <>:<IProNeutAccSg>         $IProNeutAccSg$     | \
         <>:<IProNeutDatSg>         $IProNeutDatSg$     | \
         <>:<IProNeutGenSg>         $IProNeutGenSg$     | \
         <>:<IProNeutNomSg>         $IProNeutNomSg$     | \
         <>:<Intj>                  $Intj$              | \
         <>:<Konj-Inf>              $Konj-Inf$          | \
         <>:<Konj-Kon>              $Konj-Kon$          | \
         <>:<Konj-Sub>              $Konj-Sub$          | \
         <>:<Konj-Vgl>              $Konj-Vgl$          | \
         <>:<N?/Pl_0>               $N?/Pl_0$           | \
         <>:<N?/Pl_x>               $N?/Pl_x$           | \
         <>:<NFem-Adj>              $NFem-Adj$          | \
         <>:<NFem-a/en>             $NFem-a/en$         | \
         <>:<NFem-in>               $NFem-in$           | \
         <>:<NFem-is/en>            $NFem-is/en$        | \
         <>:<NFem-is/iden>          $NFem-is/iden$      | \
         <>:<NFem-s/$sse>           $NFem-s/\$sse$      | \
         <>:<NFem-s/sse>            $NFem-s/sse$        | \
         <>:<NFem-s/ssen>           $NFem-s/ssen$       | \
         <>:<NFem/Pl_x>             $NFem/Pl_x$         | \
         <>:<NFem/Sg_0>             $NFem/Sg_0$         | \
         <>:<NFem_0_$>              $NFem_0_\$$         | \
         <>:<NFem_0_$e>             $NFem_0_\$e$        | \
         <>:<NFem_0_$en>            $NFem_0_\$en$       | \
         <>:<NFem_0_e>              $NFem_0_e$          | \
         <>:<NFem_0_en>             $NFem_0_en$         | \
         <>:<NFem_0_es>             $NFem_0_es$         | \
         <>:<NFem_0_n>              $NFem_0_n$          | \
         <>:<NFem_0_s>              $NFem_0_s$          | \
         <>:<NFem_0_x>              $NFem_0_x$          | \
         <>:<NMasc-Adj>             $NMasc-Adj$         | \
         <>:<NMasc-as/anten>        $NMasc-as/anten$    | \
         <>:<NMasc-as0/anten>       $NMasc-as0/anten$   | \
         <>:<NMasc-ns>              $NMasc-ns$          | \
         <>:<NMasc-o/en>            $NMasc-o/en$        | \
         <>:<NMasc-o/i>             $NMasc-o/i$         | \
         <>:<NMasc-s/$sse>          $NMasc-s/\$sse$     | \
         <>:<NMasc-s/Sg>            $NMasc-s/Sg$        | \
         <>:<NMasc-s/sse>           $NMasc-s/sse$       | \
         <>:<NMasc-s0/sse>          $NMasc-s0/sse$      | \
         <>:<NMasc-us/e>            $NMasc-us/e$        | \
         <>:<NMasc-us/en>           $NMasc-us/en$       | \
         <>:<NMasc-us/i>            $NMasc-us/i$        | \
         <>:<NMasc-us0/en>          $NMasc-us0/en$      | \
         <>:<NMasc-us0/i>           $NMasc-us0/i$       | \
         <>:<NMasc/Pl_0>            $NMasc/Pl_0$        | \
         <>:<NMasc/Pl_x>            $NMasc/Pl_x$        | \
         <>:<NMasc/Sg_0>            $NMasc/Sg_0$        | \
         <>:<NMasc/Sg_es>           $NMasc/Sg_es$       | \
         <>:<NMasc/Sg_s>            $NMasc/Sg_s$        | \
         <>:<NMasc_0_nen>           $NMasc_0_nen$       | \
         <>:<NMasc_0_s>             $NMasc_0_s$         | \
         <>:<NMasc_0_x>             $NMasc_0_x$         | \
         <>:<NMasc_en_en>           $NMasc_en_en$       | \
         <>:<NMasc_es_$e>           $NMasc_es_\$e$      | \
         <>:<NMasc_es_$er>          $NMasc_es_\$er$     | \
         <>:<NMasc_es_e>            $NMasc_es_e$        | \
         <>:<NMasc_es_en>           $NMasc_es_en$       | \
         <>:<NMasc_es_er>           $NMasc_es_er$       | \
         <>:<NMasc_es_es>           $NMasc_es_es$       | \
         <>:<NMasc_es_s>            $NMasc_es_s$        | \
         <>:<NMasc_n_n>             $NMasc_n_n$         | \
         <>:<NMasc_s_$>             $NMasc_s_\$$        | \
         <>:<NMasc_s_$e>            $NMasc_s_\$e$       | \
         <>:<NMasc_s_$x>            $NMasc_s_\$x$       | \
         <>:<NMasc_s_0>             $NMasc_s_0$         | \
         <>:<NMasc_s_e>             $NMasc_s_e$         | \
         <>:<NMasc_s_en>            $NMasc_s_en$        | \
         <>:<NMasc_s_er>            $NMasc_s_er$        | \
         <>:<NMasc_s_$er>           $NMasc_s_\$er$      | \
         <>:<NMasc_s_n>             $NMasc_s_n$         | \
         <>:<NMasc_s_nen>           $NMasc_s_nen$       | \
         <>:<NMasc_s_s>             $NMasc_s_s$         | \
         <>:<NMasc_s_x>             $NMasc_s_x$         | \
         <>:<NNeut-Adj/Sg>          $NNeut-Adj/Sg$      | \
         <>:<NNeut-Adj>             $NNeut-Adj$         | \
         <>:<NNeut-Herz>            $NNeut-Herz$        | \
         <>:<NNeut-Inner>           $NNeut-Inner$       | \
         <>:<NNeut-a/ata>           $NNeut-a/ata$       | \
         <>:<NNeut-a/en>            $NNeut-a/en$        | \
         <>:<NNeut-en/ina>          $NNeut-en/ina$      | \
         <>:<NNeut-o/en>            $NNeut-o/en$        | \
         <>:<NNeut-o/i>             $NNeut-o/i$         | \
         <>:<NNeut-on/a>            $NNeut-on/a$        | \
         <>:<NNeut-on/en>           $NNeut-on/en$       | \
         <>:<NNeut-s/$sser>         $NNeut-s/\$sser$    | \
         <>:<NNeut-s/sse>           $NNeut-s/sse$       | \
         <>:<NNeut-um/a>            $NNeut-um/a$        | \
         <>:<NNeut-um/en>           $NNeut-um/en$       | \
         <>:<NNeut-us0/en>          $NNeut-us0/en$      | \
         <>:<NNeut/Pl_x>            $NNeut/Pl_x$        | \
         <>:<NNeut/Sg_0>            $NNeut/Sg_0$        | \
         <>:<NNeut/Sg_es>           $NNeut/Sg_es$       | \
         <>:<NNeut/Sg_s>            $NNeut/Sg_s$        | \
         <>:<NNeut/Sg_sses>         $NNeut/Sg_sses$     | \
         <>:<NNeut_0_nen>           $NNeut_0_nen$       | \
         <>:<NNeut_0_s>             $NNeut_0_s$         | \
         <>:<NNeut_0_x>             $NNeut_0_x$         | \
         <>:<NNeut_es_$e>           $NNeut_es_\$e$      | \
         <>:<NNeut_es_$er>          $NNeut_es_\$er$     | \
         <>:<NNeut_es_e>            $NNeut_es_e$        | \
         <>:<NNeut_es_en>           $NNeut_es_en$       | \
         <>:<NNeut_es_er>           $NNeut_es_er$       | \
         <>:<NNeut_es_es>           $NNeut_es_es$       | \
         <>:<NNeut_es_s>            $NNeut_es_s$        | \
         <>:<NNeut_s_$>             $NNeut_s_\$$        | \
         <>:<NNeut_s_0>             $NNeut_s_0$         | \
         <>:<NNeut_s_e>             $NNeut_s_e$         | \
         <>:<NNeut_s_en>            $NNeut_s_en$        | \
         <>:<NNeut_s_$er>           $NNeut_s_\$er$      | \
         <>:<NNeut_s_ien>           $NNeut_s_ien$       | \
         <>:<NNeut_s_n>             $NNeut_s_n$         | \
         <>:<NNeut_s_nen>           $NNeut_s_nen$       | \
         <>:<NNeut_s_s>             $NNeut_s_s$         | \
         <>:<NNeut_s_x>             $NNeut_s_x$         | \
         <>:<Name-Fem_0>            $Name-Fem_0$        | \
         <>:<Name-Fem_apos>         $Name-Fem_apos$     | \
         <>:<Name-Fem_s>            $Name-Fem_s$        | \
         <>:<Name-Masc_0>           $Name-Masc_0$       | \
         <>:<Name-Masc_apos>        $Name-Masc_apos$    | \
         <>:<Name-Masc_es>          $Name-Masc_es$      | \
         <>:<Name-Masc_s>           $Name-Masc_s$       | \
         <>:<Name-Neut_0>           $Name-Neut_0$       | \
         <>:<Name-Neut_apos>        $Name-Neut_apos$    | \
         <>:<Name-Neut_es>          $Name-Neut_es$      | \
         <>:<Name-Neut_s>           $Name-Neut_s$       | \
         <>:<Name-Pl_0>             $Name-Pl_0$         | \
         <>:<Name-Pl_x>             $Name-Pl_x$         | \
         <>:<NTrunc>                $NTrunc$            | \
         <>:<Ord>                   $Ord$               | \
         <>:<PInd-Invar>            $PInd-Invar$        | \
         <>:<Poss>                  $Poss$              | \
         <>:<Poss-er>               $Poss-er$           | \
         <>:<Poss/Wk>               $Poss/Wk$           | \
         <>:<Poss/Wk-er>            $Poss/Wk-er$        | \
         <>:<Postp-Akk>             $Postp-Akk$         | \
         <>:<Postp-Dat>             $Postp-Dat$         | \
         <>:<Postp-Gen>             $Postp-Gen$         | \
         <>:<PPro1AccPl>            $PPro1AccPl$        | \
         <>:<PPro1AccSg>            $PPro1AccSg$        | \
         <>:<PPro1DatPl>            $PPro1DatPl$        | \
         <>:<PPro1DatSg>            $PPro1DatSg$        | \
         <>:<PPro1GenPl>            $PPro1GenPl$        | \
         <>:<PPro1GenSg>            $PPro1GenSg$        | \
         <>:<PPro1NomPl>            $PPro1NomPl$        | \
         <>:<PPro1NomSg>            $PPro1NomSg$        | \
         <>:<PPro2AccPl>            $PPro2AccPl$        | \
         <>:<PPro2AccSg>            $PPro2AccSg$        | \
         <>:<PPro2DatPl>            $PPro2DatPl$        | \
         <>:<PPro2DatSg>            $PPro2DatSg$        | \
         <>:<PPro2GenPl>            $PPro2GenPl$        | \
         <>:<PPro2GenSg>            $PPro2GenSg$        | \
         <>:<PPro2NomPl>            $PPro2NomPl$        | \
         <>:<PPro2NomSg>            $PPro2NomSg$        | \
         <>:<PProFemAccSg>          $PProFemAccSg$      | \
         <>:<PProFemDatSg>          $PProFemDatSg$      | \
         <>:<PProFemGenSg>          $PProFemGenSg$      | \
         <>:<PProFemNomSg>          $PProFemNomSg$      | \
         <>:<PProMascAccSg>         $PProMascAccSg$     | \
         <>:<PProMascDatSg>         $PProMascDatSg$     | \
         <>:<PProMascGenSg>         $PProMascGenSg$     | \
         <>:<PProMascNomSg>         $PProMascNomSg$     | \
         <>:<PProNeutAccSg>         $PProNeutAccSg$     | \
         <>:<PProNeutAccSg-s>       $PProNeutAccSg-s$   | \
         <>:<PProNeutDatSg>         $PProNeutDatSg$     | \
         <>:<PProNeutGenSg>         $PProNeutGenSg$     | \
         <>:<PProNeutNomSg>         $PProNeutNomSg$     | \
         <>:<PProNeutNomSg-s>       $PProNeutNomSg-s$   | \
         <>:<PProNoGendAccPl>       $PProNoGendAccPl$   | \
         <>:<PProNoGendDatPl>       $PProNoGendDatPl$   | \
         <>:<PProNoGendGenPl>       $PProNoGendGenPl$   | \
         <>:<PProNoGendNomPl>       $PProNoGendNomPl$   | \
         <>:<PRefl1AccSg>           $PRefl1AccSg$       | \
         <>:<PRefl1DatSg>           $PRefl1DatSg$       | \
         <>:<PRefl2AccSg>           $PRefl2AccSg$       | \
         <>:<PRefl2DatSg>           $PRefl2DatSg$       | \
         <>:<PRefl1Pl>              $PRefl1Pl$          | \
         <>:<PRefl2Pl>              $PRefl2Pl$          | \
         <>:<PRefl3>                $PRefl3$            | \
         <>:<Prep-Akk>              $Prep-Akk$          | \
         <>:<Prep-Dat>              $Prep-Dat$          | \
         <>:<Prep-Gen>              $Prep-Gen$          | \
         <>:<Prep-GDA>              $Prep-GDA$          | \
         <>:<Prep-GD>               $Prep-GD$           | \
         <>:<Prep-DA>               $Prep-DA$           | \
         <>:<Pref/Adj>              $Pref/Adj$          | \
         <>:<Pref/Adv>              $Pref/Adv$          | \
         <>:<Pref/N>                $Pref/N$            | \
         <>:<Pref/ProAdv>           $Pref/ProAdv$       | \
         <>:<Pref/Sep>              $Pref/Sep$          | \
         <>:<Pref/V>                $Pref/V$            | \
         <>:<Prep/Art-m>            $Prep/Art-m$        | \
         <>:<Prep/Art-n>            $Prep/Art-n$        | \
         <>:<Prep/Art-r>            $Prep/Art-r$        | \
         <>:<Prep/Art-s>            $Prep/Art-s$        | \
         <>:<ProAdv>                $ProAdv$            | \
         <>:<Ptkl-Adj>              $Ptkl-Adj$          | \
         <>:<Ptkl-Ant>              $Ptkl-Ant$          | \
         <>:<Ptkl-Neg>              $Ptkl-Neg$          | \
         <>:<Ptkl-Zu>               $Ptkl-Zu$           | \
         <>:<Rel>                   $Rel$               | \
         <>:<Rel-welch>             $Rel-welch$         | \
         <>:<Roman>                 $Roman$             | \
         <>:<Trunc>                 $Trunc$             | \
         <>:<VAImpPl>               $VAImpPl$           | \
         <>:<VAImpSg>               $VAImpSg$           | \
         <>:<VAPastIndPl>           $VAPastIndPl$       | \
         <>:<VAPastIndSg>           $VAPastIndSg$       | \
         <>:<VAPastKonj2>           $VAPastKonj2$       | \
         <>:<VAPres1/3PlInd>        $VAPres1/3PlInd$    | \
         <>:<VAPres1/3SgKonj>       $VAPres1/3SgKonj$   | \
         <>:<VAPres1SgInd>          $VAPres1SgInd$      | \
         <>:<VAPres2PlInd>          $VAPres2PlInd$      | \
         <>:<VAPres2SgInd>          $VAPres2SgInd$      | \
         <>:<VAPres2SgKonj>         $VAPres2SgKonj$     | \
         <>:<VAPres3SgInd>          $VAPres3SgInd$      | \
         <>:<VAPresKonjPl>          $VAPresKonjPl$      | \
         <>:<VAPresKonjSg>          $VAPresKonjSg$      | \
         <>:<VInf>                  $VInf$              | \
         <>:<VInf+PPres>            $VInf+PPres$        | \
         <>:<VInf-en>               $VInf-en$           | \
         <>:<VInf-n>                $VInf-n$            | \
         <>:<VMPast>                $VMPast$            | \
         <>:<VMPast><>:<haben>      $VMPast+haben$      | \
         <>:<VMPast><>:<sein>       $VMPast+sein$       | \
         <>:<VMPastKonj>            $VMPastKonj$        | \
         <>:<VMPresPl>              $VMPresPl$          | \
         <>:<VMPresSg>              $VMPresSg$          | \
         <>:<VPPast>                $VPPast$            | \
         <>:<VPPast><>:<haben>      $VPPast+haben$      | \
         <>:<VPPast><>:<sein>       $VPPast+sein$       | \
         <>:<VPPres>                $VPPres$            | \
         <>:<VPastIndIrreg>         $VPastIndIrreg$     | \
         <>:<VPastIndReg>           $VPastIndReg$       | \
         <>:<VPastIndStr>           $VPastIndStr$       | \
         <>:<VPastKonjStr>          $VPastKonjStr$      | \
         <>:<VPresKonj>             $VPresKonj$         | \
         <>:<VPresPlInd>            $VPresPlInd$        | \
         <>:<VVPP-en>               $VVPP-en$           | \
         <>:<VVPP-en><>:<haben>     $VVPP-en+haben$     | \
         <>:<VVPP-en><>:<sein>      $VVPP-en+sein$      | \
         <>:<VVPP-t>                $VVPP-t$            | \
         <>:<VVPP-t><>:<haben>      $VVPP-t+haben$      | \
         <>:<VVPP-t><>:<sein>       $VVPP-t+sein$       | \
         <>:<VVPastIndReg>          $VVPastIndReg$      | \
         <>:<VVPastIndStr>          $VVPastIndStr$      | \
         <>:<VVPastKonjReg>         $VVPastKonjReg$     | \
         <>:<VVPastKonjStr>         $VVPastKonjStr$     | \
         <>:<VVPastStr>             $VVPastStr$         | \
         <>:<VVPres>                $VVPres$            | \
         <>:<VVPres1>               $VVPres1$           | \
         <>:<VVPres1+Imp>           $VVPres1+Imp$       | \
         <>:<VVPres2>               $VVPres2$           | \
         <>:<VVPres2+Imp>           $VVPres2+Imp$       | \
         <>:<VVPres2+Imp0>          $VVPres2+Imp0$      | \
         <>:<VVPres2t>              $VVPres2t$          | \
         <>:<VVPresPl>              $VVPresPl$          | \
         <>:<VVPresSg>              $VVPresSg$          | \
         <>:<VVReg>                 $VVReg$             | \
         <>:<VVReg><>:<haben>       $VVReg+haben$       | \
         <>:<VVReg><>:<sein>        $VVReg+sein$        | \
         <>:<VVRegFin>              $VVRegFin$          | \
         <>:<VVReg-el/er>           $VVReg-el/er$       | \
         <>:<VVReg-el/er><>:<haben> $VVReg-el/er+haben$ | \
         <>:<VVReg-el/er><>:<sein>  $VVReg-el/er+sein$  | \
         <>:<WAdv>                  $WAdv$              | \
         <>:<W-welch>               $W-welch$           | \
         <>:<WProMascAccSg>         $WProMascAccSg$     | \
         <>:<WProMascDatSg>         $WProMascDatSg$     | \
         <>:<WProMascGenSg>         $WProMascGenSg$     | \
         <>:<WProMascNomSg>         $WProMascNomSg$     | \
         <>:<WProNeutAccSg>         $WProNeutAccSg$     | \
         <>:<WProNeutDatSg>         $WProNeutDatSg$     | \
         <>:<WProNeutGenSg>         $WProNeutGenSg$     | \
         <>:<WProNeutNomSg>         $WProNeutNomSg$


% inflection filter

ALPHABET = [#entry-type# #char# #ss-trigger# #surface-trigger# \
            <INS-E><FB><CB><VPART><Ge-Nom><UL><ge><zu> \
            <^Ax><^Px><^imp><^zz><^pp><^pl><^Gen><^Del>]

$=INFL$ = [#inflection#]:<>

$=AUX$ = [#auxiliary#]:<>

$InflFilter$ = (.* $=INFL$ $=AUX$ $=INFL$ $=AUX$ .*) | \
               (.* $=INFL$ $=INFL$ .*)
