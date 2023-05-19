% infl.fst
% Version 5.1
% Andreas Nolda 2023-05-19

% based on code from SMORLemma by Rico Sennrich
% which is in turn based on code from SMOR by Helmut Schmid

$SS$ = <OLDORTH>:<SSalt> | <>:<SS>


% nouns

% Frau; Mythos; Chaos
$NSg_0$ = {<Nom><Sg>}:{<FB>} | \
          {<Acc><Sg>}:{<FB>} | \
          {<Dat><Sg>}:{<FB>} | \
          {<Gen><Sg>}:{<FB>}

% Mensch, Menschen
$NSg_en$ = {<Nom><Sg>}:{<FB>}        | \
           {<Acc><Sg>}:{<FB>en}      | \
           {<Acc><Sg><NonSt>}:{<FB>} | \
           {<Dat><Sg>}:{<FB>en}      | \
           {<Dat><Sg><NonSt>}:{<FB>} | \ % cf. Duden-Grammatik (2016: § 333)
           {<Gen><Sg>}:{<FB>en}

% Nachbar, Nachbarn
$NSg_n$ = {<Nom><Sg>}:{<FB>}  | \
          {<Acc><Sg>}:{<FB>n} | \
          {<Dat><Sg>}:{<FB>n} | \
          {<Gen><Sg>}:{<FB>n}

% Haus, Hauses; Geist, Geist(e)s
$NSg_es$ = {<Nom><Sg>}:{<FB>}       | \
           {<Acc><Sg>}:{<FB>}       | \
           {<Dat><Sg>}:{<FB>}       | \
           {<Dat><Sg><Old>}:{<FB>e} | \ % cf. Duden-Grammatik (2016: § 317)
           {<Gen><Sg>}:{<FB>es<^Gen>}

% Opa, Opas; Klima, Klimas
$NSg_s$ = {<Nom><Sg>}:{<FB>} | \
          {<Acc><Sg>}:{<FB>} | \
          {<Dat><Sg>}:{<FB>} | \
          {<Gen><Sg>}:{<FB>s}

$NPl_x$ = {<Nom><Pl>}:{} | \
          {<Acc><Pl>}:{} | \
          {<Dat><Pl>}:{} | \
          {<Gen><Pl>}:{}

$NPl_0$ = {<Nom><Pl>}:{}  | \
          {<Acc><Pl>}:{}  | \
          {<Dat><Pl>}:{n} | \
          {<Gen><Pl>}:{}

$N_0_x$ = $NSg_0$ | \
          $NPl_x$

$N_0_0$ = $NSg_0$ | \
          $NPl_0$

$N_0_\$$ =           $NSg_0$ | \
           {}:{<UL>} $NPl_0$

$N_0_e$ =            $NSg_0$ | \
          {}:{<FB>e} $NPl_0$

$N_0_\$e$ =            $NSg_0$ | \
            {}:{<UL>e} $NPl_0$

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

$N_es_e$ =            $NSg_es$ | \
           {}:{<FB>e} $NPl_0$

$N_es_\$e$ =            $NSg_es$ | \
             {}:{<UL>e} $NPl_0$

$N_es_er$ =         $NSg_es$ | \
            {}:{er} $NPl_0$

$N_es_\$er$ =             $NSg_es$ | \
              {}:{<UL>er} $NPl_0$

$N_es_en$ =             $NSg_es$ | \
            {}:{<FB>en} $NPl_x$

$N_es_es$ =             $NSg_es$ | \
            {}:{<FB>es} $NPl_x$

$N_es_s$ =            $NSg_es$ | \
           {}:{<FB>s} $NPl_x$

$N_s_x$ = $NSg_s$ | \
          $NPl_x$

$N_s_\$x$ =           $NSg_s$ | \
            {}:{<UL>} $NPl_x$

$N_s_0$ = $NSg_s$ | \
          $NPl_0$

$N_s_\$$ =           $NSg_s$ | \
           {}:{<UL>} $NPl_0$

$N_s_e$ =            $NSg_s$ | \
          {}:{<FB>e} $NPl_0$

$N_s_\$e$ =              $NSg_s$ | \
            {<>}:{<UL>e} $NPl_0$

$N_s_er$ =             $NSg_s$ | \
           {}:{<FB>er} $NPl_x$

$N_s_\$er$ =               $NSg_s$ | \
             {<>}:{<UL>er} $NPl_0$

$N_s_en$ =             $NSg_s$ | \
           {}:{<FB>en} $NPl_x$

$N_s_n$ =            $NSg_s$ | \
          {}:{<FB>n} $NPl_x$

$N_s_s$ =            $NSg_s$ | \
          {}:{<FB>s} $NPl_x$

$N_en_en$ =             $NSg_en$ | \
            {}:{<FB>en} $NPl_x$

$N_n_n$ =            $NSg_n$ | \
          {}:{<FB>n} $NPl_x$


% masculine nouns

% Fiskus, Fiskus
$NMasc/Sg_0$ = {<+NN><Masc>}:{} $NSg_0$

% Abwasch, Abwasch(e)s; Glanz, Glanzes
$NMasc/Sg_es$ = {<+NN><Masc>}:{} $NSg_es$

% Haß, Hasses
$NMasc/Sg_es~ss$ = $SS$ $NMasc/Sg_es$

% Hagel, Hagels; Adel, Adels
$NMasc/Sg_s$ = {<+NN><Masc>}:{} $NSg_s$

% Bauten
$NMasc/Pl_x$ = {<+NN><Masc>}:{} $NPl_x$

% Kurse
$NMasc/Pl_0$ = {<+NN><Masc>}:{} $NPl_0$

% Revers, Revers, Revers
$NMasc_0_x$ = {<+NN><Masc>}:{} $N_0_x$

% Dezember, Dezember, Dezember
$NMasc_0_0$ = {<+NN><Masc>}:{} $N_0_0$

% Kodex, Kodex, Kodexe
$NMasc_0_e$ = {<+NN><Masc>}:{} $N_0_e$

% Nimbus, Nimbus, Nimbusse
$NMasc_0_e~ss$ = $SS$ $NMasc_0_e$

% Bypass, Bypass, Bypässe
$NMasc_0_\$e$ = {<+NN><Masc>}:{} $N_0_\$e$

% Embryo, Embryo, Embryonen (masculine)
$NMasc_0_nen$ =          $NMasc/Sg_0$ | \
                {}:{nen} $NMasc/Pl_x$

% Intercity, Intercity, Intercitys
$NMasc_0_s$ = {<+NN><Masc>}:{} $N_0_s$

% Tag, Tag(e)s, Tage; Kodex, Kodexes, Kodexe
$NMasc_es_e$ = {<+NN><Masc>}:{} $N_es_e$

% Bus, Busses, Busse; Erlass, Erlasses, Erlasse
$NMasc_es_e~ss$ = $SS$ $NMasc_es_e$

% Arzt, Arzt(e)s, Ärzte
$NMasc_es_\$e$ = {<+NN><Masc>}:{} $N_es_\$e$

% Bass, Basses, Bässe
$NMasc_es_\$e~ss$ = $SS$ $NMasc_es_\$e$

% Geist, Geist(e)s, Geister
$NMasc_es_er$ = {<+NN><Masc>}:{<>} $N_es_er$

% Gott, Gott(e)s, Götter
$NMasc_es_\$er$ = {<+NN><Masc>}:{} $N_es_\$er$

% Fleck, Fleck(e)s, Flecken
$NMasc_es_en$ = {<+NN><Masc>}:{} $N_es_en$

% Bugfix, Bugfix(e)s, Bugfixes
$NMasc_es_es$ = {<+NN><Masc>}:{} $N_es_es$

% Park, Park(e)s, Parks
$NMasc_es_s$ = {<+NN><Masc>}:{} $N_es_s$

% Wagen, Wagens, Wagen
$NMasc_s_x$ = {<+NN><Masc>}:{} $N_s_x$

% Garten, Gartens, Gärten
$NMasc_s_\$x$ = {<+NN><Masc>}:{} $N_s_\$x$

% Engel, Engels, Engel; Dezember, Dezembers, Dezember
$NMasc_s_0$ = {<+NN><Masc>}:{} $N_s_0$

% Apfel, Apfels, Äpfel; Vater, Vaters, Väter
$NMasc_s_\$$ = {<+NN><Masc>}:{} $N_s_\$$

% Drilling, Drillings, Drillinge
$NMasc_s_e$ = {<+NN><Masc>}:{} $N_s_e$

% Tenor, Tenors, Tenöre
$NMasc_s_\$e$ = {<+NN><Masc>}:{<>} $N_s_\$e$

% Ski, Skis, Skier
$NMasc_s_er$ = {<+NN><Masc>}:{} $N_s_er$

% Irrtum, Irrtums, Irrtümer
$NMasc_s_\$er$ = {<+NN><Masc>}:{} $N_s_\$er$

% Zeh, Zehs, Zehen
$NMasc_s_en$ = {<+NN><Masc>}:{} $N_s_en$

% Muskel, Muskels, Muskeln; See, Sees, Seen
$NMasc_s_n$ = {<+NN><Masc>}:{} $N_s_n$

% Embryo, Embryos, Embryonen (masculine)
$NMasc_s_nen$ =          $NMasc/Sg_s$ | \
                {}:{nen} $NMasc/Pl_x$

% Chef, Chefs, Chefs; Bankier, Bankiers, Bankiers
$NMasc_s_s$ = {<+NN><Masc>}:{} $N_s_s$

% Fels, Felsen, Felsen; Mensch, Menschen, Menschen
$NMasc_en_en$ = {<+NN><Masc>}:{} $N_en_en$

% Affe, Affen, Affen; Bauer, Bauern, Bauern
$NMasc_n_n$ = {<+NN><Masc>}:{} $N_n_n$

% Name, Namens, Namen; Buchstabe, Buchstabens, Buchstaben
$NMasc-ns$ = {<+NN><Masc><Nom><Sg>}:{}       | \
             {<+NN><Masc><Acc><Sg>}:{<FB>n}  | \
             {<+NN><Masc><Dat><Sg>}:{<FB>n}  | \
             {<+NN><Masc><Gen><Sg>}:{<FB>ns} | \
             {<+NN><Masc>}:{n} $NPl_x$

% Saldo, Saldos, Salden
$NMasc-o/en$ =              $NMasc/Sg_s$ | \
               {}:{<^pl>en} $NMasc/Pl_x$

% Saldo, Saldos, Saldi
$NMasc-o/i$ =             $NMasc/Sg_s$ | \
              {}:{<^pl>i} $NMasc/Pl_x$

% Atlas, Atlas, Atlanten
$NMasc-as0/anten$ =                 $NMasc/Sg_0$ | \
                    {}:{<^pl>anten} $NMasc/Pl_x$

% Atlas, Atlasses, Atlanten
$NMasc-as/anten$ =                 $NMasc/Sg_es~ss$ | \
                   {}:{<^pl>anten} $NMasc/Pl_x$

% Kursus, Kursus, Kurse
$NMasc-us/e$ =             $NMasc/Sg_0$ | \
               {}:{<^pl>e} $NMasc/Pl_0$

% Virus, Virus, Viren
$NMasc-us0/en$ =              $NMasc/Sg_0$ | \
                 {}:{<^pl>en} $NMasc/Pl_x$

% Virus, Virusse, Viren
$NMasc-us/en$ =              $NMasc/Sg_es~ss$ | \
                {}:{<^pl>en} $NMasc/Pl_x$

% Intimus, Intimus, Intimi
$NMasc-us0/i$ =            $NMasc/Sg_0$ | \
               {}:{<^pl>i} $NMasc/Pl_x$

% Intimus, Intimusse, Intimi
$NMasc-us/i$ =             $NMasc/Sg_es~ss$ | \
               {}:{<^pl>i} $NMasc/Pl_x$

% Beamte(r); Gefreite(r)
$NMasc-Adj$ = {<+NN><Masc><Nom><Sg><St>}:{r} | \
              {<+NN><Masc><Acc><Sg><St>}:{n} | \
              {<+NN><Masc><Dat><Sg><St>}:{m} | \
              {<+NN><Masc><Gen><Sg><St>}:{n} | \
              {<+NN><Masc><Nom><Pl><St>}:{}  | \
              {<+NN><Masc><Acc><Pl><St>}:{}  | \
              {<+NN><Masc><Dat><Pl><St>}:{n} | \
              {<+NN><Masc><Gen><Pl><St>}:{r} | \
              {<+NN><Masc><Nom><Sg><Wk>}:{}  | \
              {<+NN><Masc><Acc><Sg><Wk>}:{n} | \
              {<+NN><Masc><Dat><Sg><Wk>}:{n} | \
              {<+NN><Masc><Gen><Sg><Wk>}:{n} | \
              {<+NN><Masc><Nom><Pl><Wk>}:{n} | \
              {<+NN><Masc><Acc><Pl><Wk>}:{n} | \
              {<+NN><Masc><Dat><Pl><Wk>}:{n} | \
              {<+NN><Masc><Gen><Pl><Wk>}:{n}


% neuter nouns

% Abseits, Abseits
$NNeut/Sg_0$ = {<+NN><Neut>}:{} $NSg_0$

% Ausland, Ausland(e)s
$NNeut/Sg_es$ = {<+NN><Neut>}:{} $NSg_es$

% Verständnis, Verständnisses
$NNeut/Sg_es~ss$ = $SS$ $NNeut/Sg_es$

% Abitur, Abiturs
$NNeut/Sg_s$ = {<+NN><Neut>}:{} $NSg_s$

% Fresken
$NNeut/Pl_x$ = {<+NN><Neut>}:{} $NPl_x$

% Relais, Relais, Relais
$NNeut_0_x$ = {<+NN><Neut>}:{} $N_0_x$

% Gefolge, Gefolge, Gefolge
$NNeut_0_0$ = {<+NN><Neut>}:{} $N_0_0$

% Bakschisch, Bakschisch, Bakschische
$NNeut_0_e$ = {<+NN><Neut>}:{} $N_0_e$

% Rhinozeros, Rhinozeros, Rhinozerosse
$NNeut_0_e~ss$ = $SS$ $NNeut_0_e$

% Embryo, Embryo, Embryonen (neuter)
$NNeut_0_nen$ =          $NNeut/Sg_0$ | \
                {}:{nen} $NNeut/Pl_x$

% College, College, Colleges
$NNeut_0_s$ = {<+NN><Neut>}:{} $N_0_s$

% Spiel, Spiel(e)s, Spiele; Bakschisch, Bakschisch(e)s, Bakschische
$NNeut_es_e$ = {<+NN><Neut>}:{} $N_es_e$

% Zeugnis, Zeugnisses, Zeugnisse; Rhinozeros, Rhinozerosses, Rhinozerosse
$NNeut_es_e~ss$ = $SS$ $NNeut_es_e$

% Floß, Floßes, Flöße
$NNeut_es_\$e$ = {<+NN><Neut>}:{} $N_es_\$e$

% Schild, Schild(e)s, Schilder
$NNeut_es_er$ = {<+NN><Neut>}:{} $N_es_er$

% Buch, Buch(e)s, Bücher
$NNeut_es_\$er$ = {<+NN><Neut>}:{} $N_es_\$er$

% Fass, Fasses, Fässer
$NNeut_es_\$er~ss$ = $SS$ $NNeut_es_\$er$

% Bett, Bett(e)s, Betten
$NNeut_es_en$ = {<+NN><Neut>}:{} $N_es_en$

% Match, Match(e)s, Matches
$NNeut_es_es$ = {<+NN><Neut>}:{} $N_es_es$

% Tablett, Tablett(e)s, Tabletts
$NNeut_es_s$ = {<+NN><Neut>}:{} $N_es_s$

% Almosen, Almosens, Almosen
$NNeut_s_x$ = {<+NN><Neut>}:{} $N_s_x$

% Feuer, Feuers, Feuer; Gefolge, Gefolges, Gefolge
$NNeut_s_0$ = {<+NN><Neut>}:{} $N_s_0$

% Kloster, Klosters, Klöster
$NNeut_s_\$$ = {<+NN><Neut>}:{} $N_s_\$$

% Dreieck, Dreiecks, Dreiecke
$NNeut_s_e$ = {<+NN><Neut>}:{} $N_s_e$

% Spital, Spitals, Spitäler
$NNeut_s_\$er$ = {<+NN><Neut>}:{} $N_s_\$er$

% Juwel, Juwels, Juwelen
$NNeut_s_en$ = {<+NN><Neut>}:{} $N_s_en$

% Auge, Auges, Augen
$NNeut_s_n$ = {<+NN><Neut>}:{} $N_s_n$

% Herz, Herzens, Herzen
$NNeut-Herz$ = {<+NN><Neut><Nom><Sg>}:{<FB>}    | \
               {<+NN><Neut><Acc><Sg>}:{<FB>}    | \
               {<+NN><Neut><Dat><Sg>}:{<FB>en}  | \
               {<+NN><Neut><Gen><Sg>}:{<FB>ens} | \
               {<+NN><Neut><Nom><Pl>}:{<FB>en}  | \
               {<+NN><Neut><Acc><Pl>}:{<FB>en}  | \
               {<+NN><Neut><Dat><Pl>}:{<FB>en}  | \
               {<+NN><Neut><Gen><Pl>}:{<FB>en}

% Embryo, Embryos, Embryonen (neuter)
$NNeut_s_nen$ =          $NNeut/Sg_s$ | \
                {}:{nen} $NNeut/Pl_x$

% Adverb, Adverbs, Adverbien
$NNeut_s_ien$ =          $NNeut/Sg_s$ | \
                {}:{ien} $NNeut/Pl_x$

% Sofa, Sofas, Sofas; College, Colleges, Colleges
$NNeut_s_s$ = {<+NN><Neut>}:{} $N_s_s$

% Komma, Kommas, Kommata
$NNeut-a/ata$ =         $NNeut/Sg_s$ | \
                {}:{ta} $NNeut/Pl_x$

% Dogma, Dogmas, Dogmen
$NNeut-a/en$ =              $NNeut/Sg_s$ | \
               {}:{<^pl>en} $NNeut/Pl_x$

% Examen, Examens, Examina
$NNeut-en/ina$ =               $NNeut/Sg_s$ | \
                 {}:{<^pl>ina} $NNeut/Pl_x$

% Konto, Kontos, Konten
$NNeut-o/en$ =              $NNeut/Sg_s$ | \
               {}:{<^pl>en} $NNeut/Pl_x$

% Cello, Cellos, Celli
$NNeut-o/i$ =             $NNeut/Sg_s$ | \
              {}:{<^pl>i} $NNeut/Pl_x$

% Oxymoron, Oxymorons, Oxymora
$NNeut-on/a$ =             $NNeut/Sg_s$ | \
               {}:{<^pl>a} $NNeut/Pl_x$

% Stadion, Stadions, Stadien
$NNeut-on/en$ =              $NNeut/Sg_s$ | \
                {}:{<^pl>en} $NNeut/Pl_x$

% Aktivum, Aktivums, Aktiva
$NNeut-um/a$ =             $NNeut/Sg_s$ | \
               {}:{<^pl>a} $NNeut/Pl_x$

% Museum, Museums, Museen
$NNeut-um/en$ =              $NNeut/Sg_s$ | \
                {}:{<^pl>en} $NNeut/Pl_x$

% Virus, Virus, Viren
$NNeut-us0/en$ =              $NNeut/Sg_0$ | \
                 {}:{<^pl>en} $NNeut/Pl_x$

% Innere(s)
$NNeut-Inner$ = {<+NN><Neut><Nom><Sg><St>}:{<FB>es} | \
                {<+NN><Neut><Acc><Sg><St>}:{<FB>es} | \
                {<+NN><Neut><Dat><Sg><St>}:{<FB>em} | \
                {<+NN><Neut><Gen><Sg><St>}:{<FB>en} | \
                {<+NN><Neut><Gen><Sg><St>}:{<FB>n}  | \
                {<+NN><Neut><Nom><Sg><Wk>}:{<FB>e}  | \
                {<+NN><Neut><Acc><Sg><Wk>}:{<FB>e}  | \
                {<+NN><Neut><Dat><Sg><Wk>}:{<FB>en} | \
                {<+NN><Neut><Dat><Sg><Wk>}:{<FB>n}  | \
                {<+NN><Neut><Gen><Sg><Wk>}:{<FB>en} | \
                {<+NN><Neut><Gen><Sg><Wk>}:{<FB>n}

% Deutsche(s)
$NNeut-Adj/Sg$ = {<+NN><Neut><Nom><Sg><St>}:{s} | \
                 {<+NN><Neut><Acc><Sg><St>}:{s} | \
                 {<+NN><Neut><Dat><Sg><St>}:{m} | \
                 {<+NN><Neut><Gen><Sg><St>}:{n} | \
                 {<+NN><Neut><Nom><Sg><Wk>}:{}  | \
                 {<+NN><Neut><Acc><Sg><Wk>}:{}  | \
                 {<+NN><Neut><Dat><Sg><Wk>}:{n} | \
                 {<+NN><Neut><Gen><Sg><Wk>}:{n}

% Junge(s) ('young animal')
$NNeut-Adj$ = {<+NN><Neut><Nom><Sg><St>}:{s} | \
              {<+NN><Neut><Acc><Sg><St>}:{s} | \
              {<+NN><Neut><Dat><Sg><St>}:{m} | \
              {<+NN><Neut><Gen><Sg><St>}:{n} | \
              {<+NN><Neut><Nom><Pl><St>}:{}  | \
              {<+NN><Neut><Acc><Pl><St>}:{}  | \
              {<+NN><Neut><Dat><Pl><St>}:{n} | \
              {<+NN><Neut><Gen><Pl><St>}:{r} | \
              {<+NN><Neut><Nom><Sg><Wk>}:{}  | \
              {<+NN><Neut><Acc><Sg><Wk>}:{}  | \
              {<+NN><Neut><Dat><Sg><Wk>}:{n} | \
              {<+NN><Neut><Gen><Sg><Wk>}:{n} | \
              {<+NN><Neut><Nom><Pl><Wk>}:{n} | \
              {<+NN><Neut><Acc><Pl><Wk>}:{n} | \
              {<+NN><Neut><Dat><Pl><Wk>}:{n} | \
              {<+NN><Neut><Gen><Pl><Wk>}:{n}


% feminine nouns

% Matrix, Matrix
$NFem/Sg_0$ = {<+NN><Fem>}:{} $NSg_0$

% Matrizen
$NFem/Pl_x$ = {<+NN><Fem>}:{} $NPl_x$

% Ananas, Ananas, Ananas
$NFem_0_x$ = {<+NN><Fem>}:{} $N_0_x$

% Randale, Randale, Randale
$NFem_0_0$ = {<+NN><Fem>}:{} $N_0_0$

% Mutter, Mutter, Mütter
$NFem_0_\$$ = {<+NN><Fem>}:{} $N_0_\$$

% Drangsal, Drangsal, Drangsale; Retina, Retina, Retinae
$NFem_0_e$ = {<+NN><Fem>}:{} $N_0_e$

% Kenntnis, Kenntnis, Kenntnisse
$NFem_0_e~ss$ = $SS$ $NFem_0_e$

% Wand, Wand, Wände
$NFem_0_\$e$ = {<+NN><Fem>}:{} $N_0_\$e$

% Nuss, Nuss, Nüsse
$NFem_0_\$e~ss$ = $SS$ $NFem_0_\$e$

% Frau, Frau, Frauen; Arbeit, Arbeit, Arbeiten
$NFem_0_en$ = {<+NN><Fem>}:{} $N_0_en$

% Hostess, Hostess, Hostessen
$NFem_0_en~ss$ = $SS$ $NFem_0_en$

% Werkstatt, Werkstatt, Werkstätten
$NFem_0_\$en$ = {<+NN><Fem>}:{} $N_0_\$en$

% Hilfe, Hilfe, Hilfen; Tafel, Tafel, Tafeln
$NFem_0_n$ = {<+NN><Fem>}:{} $N_0_n$

% Smartwatch, Smartwatch, Smartwatches
$NFem_0_es$ = {<+NN><Fem>}:{} $N_0_es$

% Oma, Oma, Omas
$NFem_0_s$ = {<+NN><Fem>}:{} $N_0_s$

% Freundin, Freundin, Freundinnen
$NFem-in$ =          $NFem/Sg_0$ | \
            {}:{nen} $NFem/Pl_x$

% Algebra, Algebra, Algebren; Firma, Firma, Firmen
$NFem-a/en$ =              $NFem/Sg_0$ | \
              {}:{<^pl>en} $NFem/Pl_x$

% Basis, Basis, Basen
$NFem-is/en$ =              $NFem/Sg_0$ | \
               {}:{<^pl>en} $NFem/Pl_x$

% Neuritis, Neuritis, Neuritiden
$NFem-is/iden$ =                $NFem/Sg_0$ | \
                 {}:{<^pl>iden} $NFem/Pl_x$

% Frauenbeauftragte; Illustrierte
$NFem-Adj$ = {<+NN><Fem><Nom><Sg><St>}:{}  | \
             {<+NN><Fem><Acc><Sg><St>}:{}  | \
             {<+NN><Fem><Dat><Sg><St>}:{r} | \
             {<+NN><Fem><Gen><Sg><St>}:{r} | \
             {<+NN><Fem><Nom><Pl><St>}:{}  | \
             {<+NN><Fem><Acc><Pl><St>}:{}  | \
             {<+NN><Fem><Dat><Pl><St>}:{n} | \
             {<+NN><Fem><Gen><Pl><St>}:{r} | \
             {<+NN><Fem><Nom><Sg><Wk>}:{}  | \
             {<+NN><Fem><Acc><Sg><Wk>}:{}  | \
             {<+NN><Fem><Dat><Sg><Wk>}:{n} | \
             {<+NN><Fem><Gen><Sg><Wk>}:{n} | \
             {<+NN><Fem><Nom><Pl><Wk>}:{n} | \
             {<+NN><Fem><Acc><Pl><Wk>}:{n} | \
             {<+NN><Fem><Dat><Pl><Wk>}:{n} | \
             {<+NN><Fem><Gen><Pl><Wk>}:{n}


% pluralia tantum

% Kosten
$NNoGend/Pl_x$ = {<+NN><NoGend>}:{} $NPl_x$

% Leute
$NNoGend/Pl_0$ = {<+NN><NoGend>}:{} $NPl_0$


% proper names

$Name-Masc_0$ = {<+NPROP><Masc>}:{} $NSg_0$

% Andreas, Andreas'
$Name-Masc_apos$ = {<+NPROP><Masc>}:{} $NSg_0$ | \
                   {<+NPROP><Masc><Gen><Sg>}:{’}

$Name-Masc_es$ = {<+NPROP><Masc>}:{} $NSg_es$

$Name-Masc_s$ = {<+NPROP><Masc>}:{} $NSg_s$

$Name-Neut_0$ = {<+NPROP><Neut>}:{} $NSg_0$

% Paris, Paris'
$Name-Neut_apos$ = {<+NPROP><Neut>}:{} $NSg_0$ | \
                   {<+NPROP><Neut><Gen><Sg>}:{’}

$Name-Neut_es$ = {<+NPROP><Neut>}:{} $NSg_es$

$Name-Neut_s$ = {<+NPROP><Neut>}:{} $NSg_s$

$Name-Fem_0$ = {<+NPROP><Fem>}:{} $NSg_0$

% Felicitas, Felicitas'
$Name-Fem_apos$ = {<+NPROP><Fem>}:{} $NSg_0$ | \
                  {<+NPROP><Fem><Gen><Sg>}:{’}

$Name-Fem_s$ = {<+NPROP><Fem>}:{} $NSg_s$

$Name-Pl_x$ = {<+NPROP><NoGend>}:{} $NPl_x$

$Name-Pl_0$ = {<+NPROP><NoGend>}:{} $NPl_0$

% family names ending in -s, -z
$FamName_0$ = {<+NPROP><NoGend>}:{}    $NSg_0$ | \
              {<+NPROP><NoGend>}:{ens} $NPl_x$

% family names
$FamName_s$ = {<+NPROP><NoGend>}:{}  $NSg_s$ | \
              {<+NPROP><NoGend>}:{s} $NPl_x$


% adjectives

$TMP$ = {<Attr/Subst><Masc><Nom><Sg><St>}:{er}   | \
        {<Attr/Subst><Masc><Acc><Sg><St>}:{en}   | \
        {<Attr/Subst><Masc><Dat><Sg><St>}:{em}   | \
        {<Attr/Subst><Masc><Gen><Sg><St>}:{en}   | \
        {<Attr/Subst><Neut><Nom><Sg><St>}:{es}   | \
        {<Attr/Subst><Neut><Acc><Sg><St>}:{es}   | \
        {<Attr/Subst><Neut><Dat><Sg><St>}:{em}   | \
        {<Attr/Subst><Neut><Gen><Sg><St>}:{en}   | \
        {<Attr/Subst><Fem><Nom><Sg><St>}:{e}     | \
        {<Attr/Subst><Fem><Acc><Sg><St>}:{e}     | \
        {<Attr/Subst><Fem><Dat><Sg><St>}:{er}    | \
        {<Attr/Subst><Fem><Gen><Sg><St>}:{er}    | \
        {<Attr/Subst><NoGend><Nom><Pl><St>}:{e}  | \
        {<Attr/Subst><NoGend><Acc><Pl><St>}:{e}  | \
        {<Attr/Subst><NoGend><Dat><Pl><St>}:{en} | \
        {<Attr/Subst><NoGend><Gen><Pl><St>}:{er} | \
        {<Attr/Subst><Masc><Nom><Sg><Wk>}:{e}    | \
        {<Attr/Subst><Masc><Acc><Sg><Wk>}:{en}   | \
        {<Attr/Subst><Masc><Dat><Sg><Wk>}:{en}   | \
        {<Attr/Subst><Masc><Gen><Sg><Wk>}:{en}   | \
        {<Attr/Subst><Neut><Nom><Sg><Wk>}:{e}    | \
        {<Attr/Subst><Neut><Acc><Sg><Wk>}:{e}    | \
        {<Attr/Subst><Neut><Dat><Sg><Wk>}:{en}   | \
        {<Attr/Subst><Neut><Gen><Sg><Wk>}:{en}   | \
        {<Attr/Subst><Fem><Nom><Sg><Wk>}:{e}     | \
        {<Attr/Subst><Fem><Acc><Sg><Wk>}:{e}     | \
        {<Attr/Subst><Fem><Dat><Sg><Wk>}:{en}    | \
        {<Attr/Subst><Fem><Gen><Sg><Wk>}:{en}    | \
        {<Attr/Subst><NoGend><Nom><Pl><Wk>}:{en} | \
        {<Attr/Subst><NoGend><Dat><Pl><Wk>}:{en} | \
        {<Attr/Subst><NoGend><Acc><Pl><Wk>}:{en} | \
        {<Attr/Subst><NoGend><Gen><Pl><Wk>}:{en}

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

% derartig; famos; bloß
$AdjPos$ = {<+ADJ><Pos><Pred/Adv>}:{<FB>} | \
           {<+ADJ><Pos>}:{<FB>} $AdjInflSuff$

% ander-; vorig-
$AdjPosAttr$ = {<+ADJ><Pos>}:{<FB>} $AdjInflSuff$

% besser; höher
$AdjComp$ = {<+ADJ><Comp><Pred/Adv>}:{er} | \
            {<+ADJ><Comp>}:{er} $AdjInflSuff$

% mehr; weniger
$AdjComp0-mehr$ = {<+ADJ><Comp><Pred/Adv>}:{} | \
                  {<+ADJ><Comp><Attr/Subst><Invar>}:{}

% beste; höchste
$AdjSup$ = {<+ADJ><Sup><Pred/Adv>}:{sten} | \
           {<+ADJ><Sup>}:{st} $AdjInflSuff$

% allerbesten; allerhöchsten
$AdjSup-aller$ = {<+ADJ><Sup><Pred/Adv>}:{sten} | \
                 {<+ADJ><Sup>}:{st} $AdjInflSuff$

% faul, fauler, faulsten
$Adj+$ =           $AdjPos$  | \
         {}:{<FB>} $AdjComp$ | \
         {}:{<FB>} $AdjSup$

% bunt, bunter, buntesten
$Adj+e$ =            $AdjPos$  | \
          {}:{<FB>}  $AdjComp$ | \
          {}:{<FB>e} $AdjSup$

% naß, nasser, nassesten
$Adj+e~ss$ = $SS$ $Adj+e$

% frei, freier, frei(e)sten
$Adj+(e)$ =            $AdjPos$  | \
            {}:{<FB>}  $AdjComp$ | \
            {}:{<FB>}  $AdjSup$  | \
            {}:{<FB>e} $AdjSup$

% warm, wärmer, wärmsten
$Adj\$$ =           $AdjPos$  | \
          {}:{<UL>} $AdjComp$ | \
          {}:{<UL>} $AdjSup$

% kalt, kälter, kältesten
$Adj\$e$ =            $AdjPos$  | \
           {}:{<UL>}  $AdjComp$ | \
           {}:{<UL>e} $AdjSup$

% naß, nässer, nässesten
$Adj\$e~ss$ = $SS$ $Adj\$e$

% dunkel; finster
$Adj-el/er$ = {}:{<^Ax>} $Adj+$

% dunkel, dünkler, dünkelsten (regional variant)
$Adj\$-el/er$ = {}:{<^Ax>} $Adj\$$

% deutsch; [das] Deutsch
$Adj+Lang$ = $Adj+$ | \
             $NNeut/Sg_s$


% articles and pronouns

$ArtDefAttrSuff$ = {<Attr><Masc><Nom><Sg><St>}:{er}   | \
                   {<Attr><Masc><Acc><Sg><St>}:{en}   | \
                   {<Attr><Masc><Dat><Sg><St>}:{em}   | \
                   {<Attr><Masc><Gen><Sg><St>}:{es}   | \
                   {<Attr><Neut><Nom><Sg><St>}:{as}   | \
                   {<Attr><Neut><Acc><Sg><St>}:{as}   | \
                   {<Attr><Neut><Dat><Sg><St>}:{em}   | \
                   {<Attr><Neut><Gen><Sg><St>}:{es}   | \
                   {<Attr><Fem><Nom><Sg><St>}:{ie}    | \
                   {<Attr><Fem><Acc><Sg><St>}:{ie}    | \
                   {<Attr><Fem><Dat><Sg><St>}:{er}    | \
                   {<Attr><Fem><Gen><Sg><St>}:{er}    | \
                   {<Attr><NoGend><Nom><Pl><St>}:{ie} | \
                   {<Attr><NoGend><Acc><Pl><St>}:{ie} | \
                   {<Attr><NoGend><Dat><Pl><St>}:{en} | \
                   {<Attr><NoGend><Gen><Pl><St>}:{er}

$ArtDefSubstSuff$ = {<Subst><Masc><Nom><Sg><St>}:{er}     | \
                    {<Subst><Masc><Acc><Sg><St>}:{en}     | \
                    {<Subst><Masc><Dat><Sg><St>}:{em}     | \
                    {<Subst><Masc><Gen><Sg><St>}:{essen}  | \
                    {<Subst><Neut><Nom><Sg><St>}:{as}     | \
                    {<Subst><Neut><Acc><Sg><St>}:{as}     | \
                    {<Subst><Neut><Dat><Sg><St>}:{em}     | \
                    {<Subst><Neut><Gen><Sg><St>}:{essen}  | \
                    {<Subst><Fem><Nom><Sg><St>}:{ie}      | \
                    {<Subst><Fem><Acc><Sg><St>}:{ie}      | \
                    {<Subst><Fem><Dat><Sg><St>}:{er}      | \
                    {<Subst><Fem><Gen><Sg><St>}:{erer}    | \
                    {<Subst><Fem><Gen><Sg><St>}:{eren}    | \
                    {<Subst><NoGend><Nom><Pl><St>}:{ie}   | \
                    {<Subst><NoGend><Acc><Pl><St>}:{ie}   | \
                    {<Subst><NoGend><Dat><Pl><St>}:{enen} | \
                    {<Subst><NoGend><Gen><Pl><St>}:{erer} | \
                    {<Subst><NoGend><Gen><Pl><St>}:{eren}

$ArtDefSuff$ = $ArtDefAttrSuff$ | \
               $ArtDefSubstSuff$

$RelSuff$ = $ArtDefSubstSuff$

$DemDefSuff$ = $ArtDefSuff$

$DemSuff$ = {[<Attr><Subst>]<Masc><Nom><Sg><St>}:{er}   | \
            {[<Attr><Subst>]<Masc><Dat><Sg><St>}:{em}   | \
            {[<Attr><Subst>]<Masc><Acc><Sg><St>}:{en}   | \
            {[<Attr><Subst>]<Masc><Gen><Sg><St>}:{es}   | \
            {<Attr><Masc><Gen><Sg><St><NonSt>}:{en}     | \ % cf. Duden-Grammatik (2016: § 356, 379)
            {[<Attr><Subst>]<Neut><Nom><Sg><St>}:{es}   | \
            {[<Attr><Subst>]<Neut><Acc><Sg><St>}:{es}   | \
            {[<Attr><Subst>]<Neut><Dat><Sg><St>}:{em}   | \
            {[<Attr><Subst>]<Neut><Gen><Sg><St>}:{es}   | \
            {<Attr><Neut><Gen><Sg><St><NonSt>}:{en}     | \ % cf. Duden-Grammatik (2016: § 356, 379)
            {[<Attr><Subst>]<Fem><Nom><Sg><St>}:{e}     | \
            {[<Attr><Subst>]<Fem><Acc><Sg><St>}:{e}     | \
            {[<Attr><Subst>]<Fem><Dat><Sg><St>}:{er}    | \
            {[<Attr><Subst>]<Fem><Gen><Sg><St>}:{er}    | \
            {[<Attr><Subst>]<NoGend><Nom><Pl><St>}:{e}  | \
            {[<Attr><Subst>]<NoGend><Acc><Pl><St>}:{e}  | \
            {[<Attr><Subst>]<NoGend><Dat><Pl><St>}:{en} | \
            {[<Attr><Subst>]<NoGend><Gen><Pl><St>}:{er}

$DemSuff-dies$ = $DemSuff$ | \
                 {[<Attr><Subst>]<Neut><Nom><Sg><St>}:{} | \
                 {[<Attr><Subst>]<Neut><Acc><Sg><St>}:{}

$DemSuff-solch/St$ = $DemSuff$

$DemSuff-solch/Wk$ = {[<Attr><Subst>]<Masc><Nom><Sg><Wk>}:{e}    | \
                     {[<Attr><Subst>]<Masc><Acc><Sg><Wk>}:{en}   | \
                     {[<Attr><Subst>]<Masc><Dat><Sg><Wk>}:{en}   | \
                     {[<Attr><Subst>]<Masc><Gen><Sg><Wk>}:{en}   | \
                     {[<Attr><Subst>]<Neut><Nom><Sg><Wk>}:{e}    | \
                     {[<Attr><Subst>]<Neut><Acc><Sg><Wk>}:{e}    | \
                     {[<Attr><Subst>]<Neut><Dat><Sg><Wk>}:{en}   | \
                     {[<Attr><Subst>]<Neut><Gen><Sg><Wk>}:{en}   | \
                     {[<Attr><Subst>]<Fem><Nom><Sg><Wk>}:{e}     | \
                     {[<Attr><Subst>]<Fem><Acc><Sg><Wk>}:{e}     | \
                     {[<Attr><Subst>]<Fem><Dat><Sg><Wk>}:{en}    | \
                     {[<Attr><Subst>]<Fem><Gen><Sg><Wk>}:{en}    | \
                     {[<Attr><Subst>]<NoGend><Nom><Pl><Wk>}:{en} | \
                     {[<Attr><Subst>]<NoGend><Acc><Pl><Wk>}:{en} | \
                     {[<Attr><Subst>]<NoGend><Dat><Pl><Wk>}:{en} | \
                     {[<Attr><Subst>]<NoGend><Gen><Pl><Wk>}:{en}

$DemSuff-solch$ = $DemSuff-solch/St$ | \
                  $DemSuff-solch/Wk$ | \ % cf. Duden-Grammatik (2016: § 432)
                  {<Attr><Invar>}:{}

$WSuff-welch$ = $DemSuff-solch/St$ | \
                {<Attr><Invar>}:{}

$RelSuff-welch$ = $WSuff-welch$ % cf. Duden-Grammatik (2016: § 403)

$IndefSuff-welch$ = {<Subst><Masc><Nom><Sg><St>}:{er}   | \
                    {<Subst><Masc><Acc><Sg><St>}:{en}   | \
                    {<Subst><Masc><Dat><Sg><St>}:{em}   | \
                    {<Subst><Masc><Gen><Sg><St>}:{es}   | \
                    {<Subst><Neut><Nom><Sg><St>}:{es}   | \
                    {<Subst><Neut><Acc><Sg><St>}:{es}   | \
                    {<Subst><Neut><Dat><Sg><St>}:{em}   | \
                    {<Subst><Neut><Gen><Sg><St>}:{es}   | \
                    {<Subst><Fem><Nom><Sg><St>}:{e}     | \
                    {<Subst><Fem><Acc><Sg><St>}:{e}     | \
                    {<Subst><Fem><Dat><Sg><St>}:{er}    | \
                    {<Subst><Fem><Gen><Sg><St>}:{er}    | \
                    {<Subst><NoGend><Nom><Pl><St>}:{e}  | \
                    {<Subst><NoGend><Acc><Pl><St>}:{e}  | \
                    {<Subst><NoGend><Dat><Pl><St>}:{en} | \
                    {<Subst><NoGend><Gen><Pl><St>}:{er}

$IndefSuff-irgendwelch$ = $DemSuff-solch/St$

$IndefSuff-all$ = $DemSuff-solch/St$                       | \
                  {<Subst><Masc><Dat><Sg><Wk><NonSt>}:{en} | \ % cf. Duden-Grammatik (2016: § 411)
                  {<Subst><Neut><Dat><Sg><Wk><NonSt>}:{en} | \ % cf. Duden-Grammatik (2016: § 411)
                  {<Attr><Invar>}:{}

$IndefSuff-jed/St$ = {[<Attr><Subst>]<Masc><Nom><Sg><St>}:{er} | \
                     {[<Attr><Subst>]<Masc><Acc><Sg><St>}:{en} | \
                     {[<Attr><Subst>]<Masc><Dat><Sg><St>}:{em} | \
                     {[<Attr><Subst>]<Masc><Gen><Sg><St>}:{es} | \
                     {<Attr><Masc><Gen><Sg><St><NonSt>}:{en}   | \ % cf. Duden-Grammatik (2016: § 356, 422)
                     {[<Attr><Subst>]<Neut><Nom><Sg><St>}:{es} | \
                     {[<Attr><Subst>]<Neut><Acc><Sg><St>}:{es} | \
                     {[<Attr><Subst>]<Neut><Dat><Sg><St>}:{em} | \
                     {[<Attr><Subst>]<Neut><Gen><Sg><St>}:{es} | \
                     {<Attr><Neut><Gen><Sg><St><NonSt>}:{en}   | \ % cf. Duden-Grammatik (2016: § 356, 422)
                     {[<Attr><Subst>]<Fem><Nom><Sg><St>}:{e}   | \
                     {[<Attr><Subst>]<Fem><Acc><Sg><St>}:{e}   | \
                     {[<Attr><Subst>]<Fem><Dat><Sg><St>}:{er}  | \
                     {[<Attr><Subst>]<Fem><Gen><Sg><St>}:{er}

$IndefSuff-jed/Wk$ = {[<Attr><Subst>]<Masc><Nom><Sg><Wk>}:{e}  | \
                     {[<Attr><Subst>]<Masc><Acc><Sg><Wk>}:{en} | \
                     {[<Attr><Subst>]<Masc><Dat><Sg><Wk>}:{en} | \
                     {[<Attr><Subst>]<Masc><Gen><Sg><Wk>}:{en} | \
                     {[<Attr><Subst>]<Neut><Nom><Sg><Wk>}:{e}  | \
                     {[<Attr><Subst>]<Neut><Acc><Sg><Wk>}:{e}  | \
                     {[<Attr><Subst>]<Neut><Dat><Sg><Wk>}:{en} | \
                     {[<Attr><Subst>]<Neut><Gen><Sg><Wk>}:{en} | \
                     {[<Attr><Subst>]<Fem><Nom><Sg><Wk>}:{e}   | \
                     {[<Attr><Subst>]<Fem><Acc><Sg><Wk>}:{e}   | \
                     {[<Attr><Subst>]<Fem><Dat><Sg><Wk>}:{en}  | \
                     {[<Attr><Subst>]<Fem><Gen><Sg><Wk>}:{en}

$IndefSuff-jed$ = $IndefSuff-jed/St$ | \
                  $IndefSuff-jed/Wk$

$IndefSuff-jeglich$ = $DemSuff$ | \
                      $IndefSuff-jed/Wk$

$IndefSuff-saemtlich$ = $DemSuff-solch/St$ | \
                        $DemSuff-solch/Wk$ | \
                        {<Subst><Invar>}:{}

$IndefSuff-beid$ = {<Subst><Neut><Nom><Sg><St>}:{es}           | \
                   {<Subst><Neut><Acc><Sg><St>}:{es}           | \
                   {<Subst><Neut><Dat><Sg><St>}:{em}           | \
                   {<Subst><Neut><Gen><Sg><St>}:{es}           | \
                   {[<Attr><Subst>]<NoGend><Nom><Pl><St>}:{e}  | \
                   {[<Attr><Subst>]<NoGend><Acc><Pl><St>}:{e}  | \
                   {[<Attr><Subst>]<NoGend><Dat><Pl><St>}:{en} | \
                   {[<Attr><Subst>]<NoGend><Gen><Pl><St>}:{er} | \
                   {<Subst><Neut><Nom><Sg><Wk>}:{e}            | \
                   {<Subst><Neut><Acc><Sg><Wk>}:{e}            | \
                   {<Subst><Neut><Dat><Sg><Wk>}:{en}           | \
                   {<Subst><Neut><Gen><Sg><Wk>}:{en}           | \
                   {[<Attr><Subst>]<NoGend><Nom><Pl><Wk>}:{en} | \
                   {[<Attr><Subst>]<NoGend><Acc><Pl><Wk>}:{en} | \
                   {[<Attr><Subst>]<NoGend><Dat><Pl><Wk>}:{en} | \
                   {[<Attr><Subst>]<NoGend><Gen><Pl><Wk>}:{en}

$IndefSuff-einig$ = $DemSuff$

$IndefSuff-manch$ = $WSuff-welch$

$IndefSuff-mehrer$ = {[<Attr><Subst>]<Neut><Nom><Sg><St>}:{es}   | \
                     {[<Attr><Subst>]<Neut><Acc><Sg><St>}:{es}   | \
                     {[<Attr><Subst>]<NoGend><Nom><Pl><St>}:{e}  | \
                     {[<Attr><Subst>]<NoGend><Acc><Pl><St>}:{e}  | \
                     {[<Attr><Subst>]<NoGend><Dat><Pl><St>}:{en} | \
                     {[<Attr><Subst>]<NoGend><Gen><Pl><St>}:{er}

$IndefSuff0$ = {[<Attr><Subst>]<Invar>}:{}

$ArtIndefAttrSuff$ = {<Attr><Masc><Nom><Sg><NoInfl>}:{} | \
                     {<Attr><Masc><Acc><Sg><St>}:{en}   | \
                     {<Attr><Masc><Dat><Sg><St>}:{em}   | \
                     {<Attr><Masc><Gen><Sg><St>}:{es}   | \
                     {<Attr><Neut><Nom><Sg><NoInfl>}:{} | \
                     {<Attr><Neut><Acc><Sg><NoInfl>}:{} | \
                     {<Attr><Neut><Dat><Sg><St>}:{em}   | \
                     {<Attr><Neut><Gen><Sg><St>}:{es}   | \
                     {<Attr><Fem><Nom><Sg><St>}:{e}     | \
                     {<Attr><Fem><Acc><Sg><St>}:{e}     | \
                     {<Attr><Fem><Dat><Sg><St>}:{er}    | \
                     {<Attr><Fem><Gen><Sg><St>}:{er}

$ArtIndefSubstSuff$ = {<Subst><Masc><Nom><Sg><St>}:{er} | \
                      {<Subst><Masc><Acc><Sg><St>}:{en} | \
                      {<Subst><Masc><Dat><Sg><St>}:{em} | \
                      {<Subst><Masc><Gen><Sg><St>}:{es} | \
                      {<Subst><Neut><Nom><Sg><St>}:{es} | \
                      {<Subst><Neut><Nom><Sg><St>}:{s}  | \
                      {<Subst><Neut><Acc><Sg><St>}:{es} | \
                      {<Subst><Neut><Acc><Sg><St>}:{s}  | \
                      {<Subst><Neut><Dat><Sg><St>}:{em} | \
                      {<Subst><Neut><Gen><Sg><St>}:{es} | \
                      {<Subst><Fem><Nom><Sg><St>}:{e}   | \
                      {<Subst><Fem><Acc><Sg><St>}:{e}   | \
                      {<Subst><Fem><Dat><Sg><St>}:{er}  | \
                      {<Subst><Fem><Gen><Sg><St>}:{er}

$ArtIndefSuff$ = $ArtIndefAttrSuff$ | \
                 $ArtIndefSubstSuff$

$IndefSuff-ein/St$ = $ArtIndefSubstSuff$

$IndefSuff-ein/Wk$ = {<Subst><Masc><Nom><Sg><Wk>}:{e}  | \
                     {<Subst><Masc><Acc><Sg><Wk>}:{en} | \
                     {<Subst><Masc><Dat><Sg><Wk>}:{en} | \
                     {<Subst><Masc><Gen><Sg><Wk>}:{en} | \
                     {<Subst><Neut><Nom><Sg><Wk>}:{e}  | \
                     {<Subst><Neut><Acc><Sg><Wk>}:{e}  | \
                     {<Subst><Neut><Dat><Sg><Wk>}:{en} | \
                     {<Subst><Neut><Gen><Sg><Wk>}:{en} | \
                     {<Subst><Fem><Nom><Sg><Wk>}:{e}   | \
                     {<Subst><Fem><Acc><Sg><Wk>}:{e}   | \
                     {<Subst><Fem><Dat><Sg><Wk>}:{en}  | \
                     {<Subst><Fem><Gen><Sg><Wk>}:{en}

$IndefSuff-ein$ = $IndefSuff-ein/St$ | \
                  $IndefSuff-ein/Wk$

$ArtNegAttrSuff$ = $ArtIndefAttrSuff$                      | \
                   {<Attr><Masc><Gen><Sg><St><NonSt>}:{en} | \ % cf. Duden-Grammatik (2016: § 356, 425)
                   {<Attr><Neut><Gen><Sg><St><NonSt>}:{en} | \ % cf. Duden-Grammatik (2016: § 356, 425)
                   {<Attr><NoGend><Nom><Pl><St>}:{e}       | \
                   {<Attr><NoGend><Acc><Pl><St>}:{e}       | \
                   {<Attr><NoGend><Dat><Pl><St>}:{en}      | \
                   {<Attr><NoGend><Gen><Pl><St>}:{er}

$ArtNegSubstSuff$ = $ArtIndefSubstSuff$                 | \
                    {<Subst><NoGend><Nom><Pl><St>}:{e}  | \
                    {<Subst><NoGend><Acc><Pl><St>}:{e}  | \
                    {<Subst><NoGend><Dat><Pl><St>}:{en} | \
                    {<Subst><NoGend><Gen><Pl><St>}:{er}

$ArtNegSuff$ =  $ArtNegAttrSuff$ | \
                $ArtNegSubstSuff$

$IndefSuff-kein$ = $ArtNegSubstSuff$

$PossSuff/St$ = $ArtNegSuff$

$PossSuff/Wk$ = {<Subst><Masc><Nom><Sg><Wk>}:{e}    | \
                {<Subst><Masc><Acc><Sg><Wk>}:{en}   | \
                {<Subst><Masc><Dat><Sg><Wk>}:{en}   | \
                {<Subst><Masc><Gen><Sg><Wk>}:{en}   | \
                {<Subst><Neut><Nom><Sg><Wk>}:{e}    | \
                {<Subst><Neut><Acc><Sg><Wk>}:{e}    | \
                {<Subst><Neut><Dat><Sg><Wk>}:{en}   | \
                {<Subst><Neut><Gen><Sg><Wk>}:{en}   | \
                {<Subst><Fem><Nom><Sg><Wk>}:{e}     | \
                {<Subst><Fem><Acc><Sg><Wk>}:{e}     | \
                {<Subst><Fem><Dat><Sg><Wk>}:{en}    | \
                {<Subst><Fem><Gen><Sg><Wk>}:{en}    | \
                {<Subst><NoGend><Nom><Pl><Wk>}:{en} | \
                {<Subst><NoGend><Acc><Pl><Wk>}:{en} | \
                {<Subst><NoGend><Dat><Pl><Wk>}:{en} | \
                {<Subst><NoGend><Gen><Pl><Wk>}:{en}

$PossSuff$ = $PossSuff/St$ | \
             $PossSuff/Wk$

$IProSuff0$ = {<Invar>}:{}

$IProSuff$ = {<Nom><Sg>}:{}   | \
             {<Acc><Sg>}:{en} | \
             {<Acc><Sg>}:{}   | \
             {<Dat><Sg>}:{em} | \
             {<Dat><Sg>}:{}   | \
             {<Gen><Sg>}:{es}

$IProSuff-jedermann$ = {<Nom><Sg>}:{} | \
                       {<Acc><Sg>}:{} | \
                       {<Dat><Sg>}:{} | \
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

$CardSuff0$ = {[<Attr><Subst>]<Invar>}:{}

$CardSuff-ein/St$ = $ArtIndefSuff$

$CardSuff-ein/Wk$ = {[<Attr><Subst>]<Masc><Nom><Sg><Wk>}:{e}  | \
                    {[<Attr><Subst>]<Masc><Acc><Sg><Wk>}:{en} | \
                    {[<Attr><Subst>]<Masc><Dat><Sg><Wk>}:{en} | \
                    {[<Attr><Subst>]<Masc><Gen><Sg><Wk>}:{en} | \
                    {[<Attr><Subst>]<Neut><Nom><Sg><Wk>}:{e}  | \
                    {[<Attr><Subst>]<Neut><Acc><Sg><Wk>}:{e}  | \
                    {[<Attr><Subst>]<Neut><Dat><Sg><Wk>}:{en} | \
                    {[<Attr><Subst>]<Neut><Gen><Sg><Wk>}:{en} | \
                    {[<Attr><Subst>]<Fem><Nom><Sg><Wk>}:{e}   | \
                    {[<Attr><Subst>]<Fem><Acc><Sg><Wk>}:{e}   | \
                    {[<Attr><Subst>]<Fem><Dat><Sg><Wk>}:{en}  | \
                    {[<Attr><Subst>]<Fem><Gen><Sg><Wk>}:{en}

$CardSuff-ein$ = $CardSuff-ein/St$ | \
                 $CardSuff-ein/Wk$

$CardSuff-kein$ = $ArtNegSuff$

$CardSuff-zwei$ = $CardSuff0$                                 | \
                  {<Subst><NoGend><Nom><Pl><St><NonSt>}:{e}   | \ % cf. Duden-Grammatik (2016: § 511)
                  {<Subst><NoGend><Acc><Pl><St><NonSt>}:{e}   | \ % cf. Duden-Grammatik (2016: § 511)
                  {<Subst><NoGend><Dat><Pl><St>}:{en}         | \ % cf. Duden-Grammatik (2016: § 511)
                  {[<Attr><Subst>]<NoGend><Gen><Pl><St>}:{er} | \   % cf. Duden-Grammatik (2016: § 511)
                  {<Subst><NoGend><Nom><Pl><Wk><NonSt>}:{e}   | \ % cf. Duden-Grammatik (2016: § 511)
                  {<Subst><NoGend><Acc><Pl><Wk><NonSt>}:{e}   | \ % cf. Duden-Grammatik (2016: § 511)
                  {<Subst><NoGend><Dat><Pl><Wk>}:{en}             % cf. Duden-Grammatik (2016: § 511)

$CardSuff-vier$ = $CardSuff0$                               | \
                  {<Subst><NoGend><Nom><Pl><St><NonSt>}:{e} | \ % cf. Duden-Grammatik (2016: § 511)
                  {<Subst><NoGend><Acc><Pl><St><NonSt>}:{e} | \ % cf. Duden-Grammatik (2016: § 511)
                  {<Subst><NoGend><Dat><Pl><St>}:{en}       | \ % cf. Duden-Grammatik (2016: § 511)
                  {<Subst><NoGend><Nom><Pl><Wk><NonSt>}:{e} | \ % cf. Duden-Grammatik (2016: § 511)
                  {<Subst><NoGend><Acc><Pl><Wk><NonSt>}:{e} | \ % cf. Duden-Grammatik (2016: § 511)
                  {<Subst><NoGend><Dat><Pl><Wk>}:{en}           % cf. Duden-Grammatik (2016: § 511)

$CardSuff-sieben$ = $CardSuff0$                               | \
                    {<Subst><NoGend><Nom><Pl><St><NonSt>}:{e} | \ % cf. Duden-Grammatik (2016: § 511)
                    {<Subst><NoGend><Acc><Pl><St><NonSt>}:{e} | \ % cf. Duden-Grammatik (2016: § 511)
                    {<Subst><NoGend><Nom><Pl><Wk><NonSt>}:{e} | \ % cf. Duden-Grammatik (2016: § 511)
                    {<Subst><NoGend><Acc><Pl><Wk><NonSt>}:{e}     % cf. Duden-Grammatik (2016: § 511)

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

% öfter; lieber
$AdvComp$ = {<+ADV><Comp>}:{er}

% öftesten; liebsten; meisten
$AdvSup$ = {<+ADV><Sup>}:{sten}


% verbs

% sei; hab(e); werde; tu
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
$VAPres1/3PlInd$ = {<+V><1><Pl><Pres><Ind>}:{} | \
                   {<+V><3><Pl><Pres><Ind>}:{}

% seid; habt; werdet; tut
$VAPres2PlInd$ = {<+V><2><Pl><Pres><Ind>}:{}

% sei; habe; werde; tue
$VAPres1/3SgSubj$ = {<+V><1><Sg><Pres><Subj>}:{<FB>} | \
                    {<+V><3><Sg><Pres><Subj>}:{<FB>}

% seist, seiest; habest; werdest; tuest
$VAPres2SgSubj$ = {<+V><2><Sg><Pres><Subj>}:{<FB>st}

$VAPresSubjSg$ = {<+V><1><Sg><Pres><Subj>}:{<FB>}   | \
                 {<+V><2><Sg><Pres><Subj>}:{<FB>st} | \
                 {<+V><3><Sg><Pres><Subj>}:{<FB>}

$VAPresSubjPl$ = {<+V><1><Pl><Pres><Subj>}:{<FB>n} | \
                 {<+V><2><Pl><Pres><Subj>}:{<FB>t} | \
                 {<+V><3><Pl><Pres><Subj>}:{<FB>n}

% ward, wardst
$VAPastIndSg$ = {<+V><1><Sg><Past><Ind>}:{<FB>}   | \
                {<+V><2><Sg><Past><Ind>}:{<FB>st} | \
                {<+V><3><Sg><Past><Ind>}:{<FB>}

% wurden, wurdet
$VAPastIndPl$ = {<+V><1><Pl><Past><Ind>}:{<FB>en}   | \
                {<+V><2><Pl><Past><Ind>}:{<INS-E>t} | \
                {<+V><3><Pl><Past><Ind>}:{<FB>en}

$VAPastSubj2$ = {<+V><2><Sg><Past><Subj>}:{<FB>st} | \
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

% kommt; schaut; arbeitet
$VImpPl$ = {<+V><Imp><Pl>}:{<INS-E>t<^imp>}

% komm; schau; arbeite
$VImpSg$ = {<+V><Imp><Sg>}:{<INS-E><^imp>}

% flicht
$VImpSg0$ = {<+V><Imp><Sg>}:{<^imp>}

% will; bedarf
$VPres1Irreg$ = {<+V><1><Sg><Pres><Ind>}:{<FB>}

% liebe; rate; sammle
$VPres1Reg$ = {<+V><1><Sg><Pres><Ind>}:{<FB>e}

% hilfst; rätst
$VPres2Irreg$ = {<+V><2><Sg><Pres><Ind>}:{<FB>st}

% liebst; bietest; sammelst
$VPres2Reg$ = {<+V><2><Sg><Pres><Ind>}:{<INS-E>st}

% rät; will
$VPres3Irreg$ = {<+V><3><Sg><Pres><Ind>}:{<FB>}

% liebt; hilft; sammelt
$VPres3Reg$ = {<+V><3><Sg><Pres><Ind>}:{<INS-E>t}

% lieben; wollen; sammeln
% liebt; bietet; sammelt
$VPresPlInd$ = {<+V><1><Pl><Pres><Ind>}:{<FB>en}   | \
               {<+V><2><Pl><Pres><Ind>}:{<INS-E>t} | \
               {<+V><3><Pl><Pres><Ind>}:{<FB>en}

% liebe; wolle; sammle
% liebest; wollest; sammelst
% lieben; wollen; sammeln
% liebet; wollet; sammelt
$VPresSubj$ = {<+V><1><Sg><Pres><Subj>}:{<FB>e}   | \
              {<+V><2><Sg><Pres><Subj>}:{<FB>est} | \
              {<+V><3><Sg><Pres><Subj>}:{<FB>e}   | \
              {<+V><1><Pl><Pres><Subj>}:{<FB>en}  | \
              {<+V><2><Pl><Pres><Subj>}:{<FB>et}  | \
              {<+V><3><Pl><Pres><Subj>}:{<FB>en}

% brachte
$VPastIndReg$ = {<+V><1><Sg><Past><Ind>}:{<INS-E>te}   | \
                {<+V><2><Sg><Past><Ind>}:{<INS-E>test} | \
                {<+V><3><Sg><Past><Ind>}:{<INS-E>te}   | \
                {<+V><1><Pl><Past><Ind>}:{<INS-E>ten}  | \
                {<+V><2><Pl><Past><Ind>}:{<INS-E>tet}  | \
                {<+V><3><Pl><Past><Ind>}:{<INS-E>ten}

% wurde
$VPastIndIrreg$ = {<+V><1><Sg><Past><Ind>}:{<FB>e}   | \
                  {<+V><2><Sg><Past><Ind>}:{<FB>est} | \
                  {<+V><3><Sg><Past><Ind>}:{<FB>e}   | \
                  {<+V><1><Pl><Past><Ind>}:{<FB>en}  | \
                  {<+V><2><Pl><Past><Ind>}:{<FB>et}  | \
                  {<+V><3><Pl><Past><Ind>}:{<FB>en}

% fuhr; ritt; fand
% fuhrst; rittest; fandest
$VPastIndStr$ = {<+V><1><Sg><Past><Ind>}:{<FB>}      | \
                {<+V><2><Sg><Past><Ind>}:{<INS-E>st} | \
                {<+V><3><Sg><Past><Ind>}:{<FB>}      | \
                {<+V><1><Pl><Past><Ind>}:{<FB>en}    | \
                {<+V><2><Pl><Past><Ind>}:{<INS-E>t}  | \
                {<+V><3><Pl><Past><Ind>}:{<FB>en}

% brächte
$VPastSubjReg$ = {<+V><1><Sg><Past><Subj>}:{<INS-E>te}   | \
                 {<+V><2><Sg><Past><Subj>}:{<INS-E>test} | \
                 {<+V><3><Sg><Past><Subj>}:{<INS-E>te}   | \
                 {<+V><1><Pl><Past><Subj>}:{<INS-E>ten}  | \
                 {<+V><2><Pl><Past><Subj>}:{<INS-E>tet}  | \
                 {<+V><3><Pl><Past><Subj>}:{<INS-E>ten}

% führe; ritte; fände
$VPastSubjStr$ = {<+V><1><Sg><Past><Subj>}:{<FB>e}   | \
                 {<+V><2><Sg><Past><Subj>}:{<FB>est} | \
                 {<+V><3><Sg><Past><Subj>}:{<FB>e}   | \
                 {<+V><1><Pl><Past><Subj>}:{<FB>en}  | \
                 {<+V><2><Pl><Past><Subj>}:{<FB>et}  | \
                 {<+V><3><Pl><Past><Subj>}:{<FB>en}

$VInflPres2$ = $VPres2Irreg$ | \
               $VPres3Reg$

$VInflPres2t$ = $VPres2Irreg$ | \
                $VPres3Irreg$

$VInflPres1$ = $VPres1Reg$  | \
               $VPresPlInd$ | \
               $VPresSubj$  | \
               $VImpPl$

$VInflPresReg$ = $VInflPres1$ | \
                 $VPres2Reg$  | \
                 $VPres3Reg$  | \
                 $VImpSg$

$VInflReg$ =  $VInflPresReg$ | \
              $VPastIndReg$  | \
              $VPastSubjReg$

$VModInflSg$ = $VPres1Irreg$ | \
               $VPres2Reg$   | \
               $VPres3Irreg$

$VModInflPl$ = $VPresPlInd$ | \
               $VPresSubj$

$VVPres$ = $VInflPresReg$ | \
           $VInfStem$

$VVPres1$ = $VInflPres1$ | \
            $VInfStem$

$VVPres1~ss$ = $SS$ $VVPres1$

$VVPres1+Imp$ = $VImpSg$ | \
                $VVPres1$

$VVPres1+Imp~ss$ = $SS$ $VVPres1+Imp$

$VVPres2$ = $VInflPres2$

$VVPres2~ss$ = $SS$ $VVPres2$

$VVPres2t$ = $VInflPres2t$

$VVPres2+Imp$ = $VImpSg$ | \
                $VVPres2$

$VVPres2+Imp~ss$ = $SS$ $VVPres2+Imp$

$VVPres2+Imp0$ = $VImpSg0$ | \
                 $VVPres2t$

% bedarf-; weiss-
$VVPresSg$ = $VModInflSg$

% bedürf-; wiss-
$VVPresPl$ = $VModInflPl$ | \
             $VInfStem$

$VVPastIndReg$ = $VPastIndReg$

$VVPastIndReg~ss$ = $SS$ $VVPastIndReg$

$VVPastIndStr$ = $VPastIndStr$

$VVPastIndStr~ss$ = $SS$ $VPastIndStr$

$VVPastSubjReg$ = $VPastSubjReg$

$VVPastSubjReg~ss$ = $SS$ $VVPastSubjReg$

$VVPastSubjStr$ = $VPastSubjStr$

$VVPastSubjOld$ = $VVPastSubjStr$ {<Old>}:{}

$VVPastStr$ = $VVPastIndStr$ | \
              $VVPastSubjStr$

$VVPastStr~ss$ = $SS$ $VVPastStr$

$VVRegFin$ = $VInflReg$

$VVReg$ = $VInflReg$ | \
          $VPP-t$    | \
          $VInfStem$

$VVReg~ss$ = $SS$ $VVReg$

$VVReg+haben$ = $VInflReg$ | \
                $VPP-t$ $haben$ | \
                $VInfStem$

$VVReg+haben~ss$ = $SS$ $VVReg+haben$

$VVReg+sein$ = $VInflReg$ | \
               $VPP-t$ $sein$ | \
               $VInfStem$

$VVReg+sein~ss$ = $SS$ $VVReg+sein$

$VVReg-el/er$ = $VVReg$

$VVReg-el/er+haben$ = $VVReg+haben$

$VVReg-el/er+sein$ = $VVReg+sein$

$VMPastSubj$ = $VPastSubjReg$

$VMPresSg$ = $VModInflSg$

$VMPresSg~ss$ = $SS$ $VMPresSg$

$VMPresPl$ = $VModInflPl$ | \
             $VInfStem$

$VMPresPl~ss$ = $SS$ $VMPresPl$

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

$VVPP-t~ss$ = $SS$ $VPP-t$

$VVPP-t+haben$ = $VPP-t$ $haben$

$VVPP-t+haben~ss$ = $SS$ $VVPP-t+haben$

$VVPP-t+sein$ = $VPP-t$ $sein$

$VVPP-t+sein~ss$ = $SS$ $VVPP-t+sein$


% adpositions

% unter
$Prep$ = {<+PREP>}:{}

% unterm
$Prep/Art-m$ = {<+PREPART><Masc><Dat><Sg>}:{} | \
               {<+PREPART><Neut><Dat><Sg>}:{}

% untern
$Prep/Art-n$ = {<+PREPART><Masc><Acc><Sg>}:{}

% unters
$Prep/Art-s$ = {<+PREPART><Neut><Acc><Sg>}:{}

% zur
$Prep/Art-r$ = {<+PREPART><Fem><Dat><Sg>}:{}

% zufolge
$Postp$ = {<+POSTP>}:{}

$Circp$ = {<+CIRCP>}:{}


% abbreviations

% Kfm. (= Kaufmann)
$Abbr_NMasc$ = {<+NN><Masc><Invar>}:{}

% Gr. (= Gros)
$Abbr_NNeut$ = {<+NN><Neut><Invar>}:{}

% Kffr. (= Kauffrau)
$Abbr_NFem$ = {<+NN><Fem><Invar>}:{}

% Gebr. (= Gebrüder)
$Abbr_NNoGend$ = {<+NN><NoGend><Invar>}:{}

% f. (= folgende)
$Abbr_Adj$ = {<+ADJ><Pos><Invar>}:{}

% Ew. (= Euer)
$Abbr_Poss$ = {<+POSS><Attr><Invar>}:{}


% other words

$Intj$ = {<+INTJ>}:{}

$Conj-Inf$ = {<+CONJ><Inf>}:{}

$Conj-Coord$ = {<+CONJ><Coord>}:{}

$Conj-Sub$ = {<+CONJ><Sub>}:{}

$Conj-Compar$ = {<+CONJ><Compar>}:{}

$PInd-Invar$ = {<+INDEF><Invar>}:{}

$ProAdv$ = {<+PROADV>}:{}

$Ptcl-Adj$ = {<+PTCL><Adj>}:{}

$Ptcl-Neg$ = {<+PTCL><Neg>}:{}

$Ptcl-zu$ = {<+PTCL><zu>}:{}

$WAdv$ = {<+WADV>}:{}

$Pref/Adv$ = {<+VPART><Adv>}:{}

$Pref/Adj$ = {<+VPART><Adj>}:{}

$Pref/ProAdv$ = {<+VPART><ProAdv>}:{}

$Pref/N$ = {<+VPART><NN>}:{}

$Pref/V$ = {<+VPART><V>}:{}

$Pref/Sep$ = {<+VPART>}:{}


% inflection transducer

$INFL$ = <>:<Abbr_Adj>              $Abbr_Adj$          | \
         <>:<Abbr_NFem>             $Abbr_NFem$         | \
         <>:<Abbr_NMasc>            $Abbr_NMasc$        | \
         <>:<Abbr_NNeut>            $Abbr_NNeut$        | \
         <>:<Abbr_NNoGend>          $Abbr_NNoGend$      | \
         <>:<Abbr_Poss>             $Abbr_Poss$         | \
         <>:<Adj$-el/er>            $Adj\$-el/er$       | \
         <>:<Adj$>                  $Adj\$$             | \
         <>:<Adj$e>                 $Adj\$e$            | \
         <>:<Adj$e~ss>              $Adj\$e~ss$         | \
         <>:<Adj+(e)>               $Adj+(e)$           | \
         <>:<Adj+>                  $Adj+$              | \
         <>:<Adj+e>                 $Adj+e$             | \
         <>:<Adj+e~ss>              $Adj+e~ss$          | \
         <>:<Adj+Lang>              $Adj+Lang$          | \
         <>:<Adj-el/er>             $Adj-el/er$         | \
         <>:<AdjComp0-mehr>         $AdjComp0-mehr$     | \
         <>:<AdjComp>               $AdjComp$           | \
         <>:<AdjPos0-viel>          $AdjPos0-viel$      | \
         <>:<AdjPos0>               $AdjPos0$           | \
         <>:<AdjPos0Attr>           $AdjPos0Attr$       | \
         <>:<AdjPos0AttrSubst>      $AdjPos0AttrSubst$  | \
         <>:<AdjPos>                $AdjPos$            | \
         <>:<AdjPosAttr>            $AdjPosAttr$        | \
         <>:<AdjPosPred>            $AdjPosPred$        | \
         <>:<AdjSup-aller>          $AdjSup-aller$      | \
         <>:<AdjSup>                $AdjSup$            | \
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
         <>:<Conj-Compar>           $Conj-Compar$       | \
         <>:<Conj-Coord>            $Conj-Coord$        | \
         <>:<Conj-Inf>              $Conj-Inf$          | \
         <>:<Conj-Sub>              $Conj-Sub$          | \
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
         <>:<NFem-a/en>             $NFem-a/en$         | \
         <>:<NFem-Adj>              $NFem-Adj$          | \
         <>:<NFem-in>               $NFem-in$           | \
         <>:<NFem-is/en>            $NFem-is/en$        | \
         <>:<NFem-is/iden>          $NFem-is/iden$      | \
         <>:<NFem/Pl_x>             $NFem/Pl_x$         | \
         <>:<NFem/Sg_0>             $NFem/Sg_0$         | \
         <>:<NFem_0_$>              $NFem_0_\$$         | \
         <>:<NFem_0_$e>             $NFem_0_\$e$        | \
         <>:<NFem_0_$e~ss>          $NFem_0_\$e~ss$     | \
         <>:<NFem_0_$en>            $NFem_0_\$en$       | \
         <>:<NFem_0_0>              $NFem_0_0$          | \
         <>:<NFem_0_e>              $NFem_0_e$          | \
         <>:<NFem_0_e~ss>           $NFem_0_e~ss$       | \
         <>:<NFem_0_en>             $NFem_0_en$         | \
         <>:<NFem_0_en~ss>          $NFem_0_en~ss$      | \
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
         <>:<NMasc-us/e>            $NMasc-us/e$        | \
         <>:<NMasc-us/en>           $NMasc-us/en$       | \
         <>:<NMasc-us/i>            $NMasc-us/i$        | \
         <>:<NMasc-us0/en>          $NMasc-us0/en$      | \
         <>:<NMasc-us0/i>           $NMasc-us0/i$       | \
         <>:<NMasc/Pl_0>            $NMasc/Pl_0$        | \
         <>:<NMasc/Pl_x>            $NMasc/Pl_x$        | \
         <>:<NMasc/Sg_0>            $NMasc/Sg_0$        | \
         <>:<NMasc/Sg_es>           $NMasc/Sg_es$       | \
         <>:<NMasc/Sg_es~ss>        $NMasc/Sg_es~ss$    | \
         <>:<NMasc/Sg_s>            $NMasc/Sg_s$        | \
         <>:<NMasc_0_$e>            $NMasc_0_\$e$       | \
         <>:<NMasc_0_0>             $NMasc_0_0$         | \
         <>:<NMasc_0_e>             $NMasc_0_e$         | \
         <>:<NMasc_0_e~ss>          $NMasc_0_e~ss$      | \
         <>:<NMasc_0_nen>           $NMasc_0_nen$       | \
         <>:<NMasc_0_s>             $NMasc_0_s$         | \
         <>:<NMasc_0_x>             $NMasc_0_x$         | \
         <>:<NMasc_en_en>           $NMasc_en_en$       | \
         <>:<NMasc_es_$e>           $NMasc_es_\$e$      | \
         <>:<NMasc_es_$e~ss>        $NMasc_es_\$e~ss$   | \
         <>:<NMasc_es_$er>          $NMasc_es_\$er$     | \
         <>:<NMasc_es_e>            $NMasc_es_e$        | \
         <>:<NMasc_es_e~ss>         $NMasc_es_e~ss$     | \
         <>:<NMasc_es_en>           $NMasc_es_en$       | \
         <>:<NMasc_es_er>           $NMasc_es_er$       | \
         <>:<NMasc_es_es>           $NMasc_es_es$       | \
         <>:<NMasc_es_s>            $NMasc_es_s$        | \
         <>:<NMasc_n_n>             $NMasc_n_n$         | \
         <>:<NMasc_s_$>             $NMasc_s_\$$        | \
         <>:<NMasc_s_$e>            $NMasc_s_\$e$       | \
         <>:<NMasc_s_$er>           $NMasc_s_\$er$      | \
         <>:<NMasc_s_$x>            $NMasc_s_\$x$       | \
         <>:<NMasc_s_0>             $NMasc_s_0$         | \
         <>:<NMasc_s_e>             $NMasc_s_e$         | \
         <>:<NMasc_s_en>            $NMasc_s_en$        | \
         <>:<NMasc_s_er>            $NMasc_s_er$        | \
         <>:<NMasc_s_n>             $NMasc_s_n$         | \
         <>:<NMasc_s_nen>           $NMasc_s_nen$       | \
         <>:<NMasc_s_s>             $NMasc_s_s$         | \
         <>:<NMasc_s_x>             $NMasc_s_x$         | \
         <>:<NNeut-a/ata>           $NNeut-a/ata$       | \
         <>:<NNeut-a/en>            $NNeut-a/en$        | \
         <>:<NNeut-Adj/Sg>          $NNeut-Adj/Sg$      | \
         <>:<NNeut-Adj>             $NNeut-Adj$         | \
         <>:<NNeut-en/ina>          $NNeut-en/ina$      | \
         <>:<NNeut-Herz>            $NNeut-Herz$        | \
         <>:<NNeut-Inner>           $NNeut-Inner$       | \
         <>:<NNeut-o/en>            $NNeut-o/en$        | \
         <>:<NNeut-o/i>             $NNeut-o/i$         | \
         <>:<NNeut-on/a>            $NNeut-on/a$        | \
         <>:<NNeut-on/en>           $NNeut-on/en$       | \
         <>:<NNeut-um/a>            $NNeut-um/a$        | \
         <>:<NNeut-um/en>           $NNeut-um/en$       | \
         <>:<NNeut-us0/en>          $NNeut-us0/en$      | \
         <>:<NNeut/Pl_x>            $NNeut/Pl_x$        | \
         <>:<NNeut/Sg_0>            $NNeut/Sg_0$        | \
         <>:<NNeut/Sg_es>           $NNeut/Sg_es$       | \
         <>:<NNeut/Sg_es~ss>        $NNeut/Sg_es~ss$    | \
         <>:<NNeut/Sg_s>            $NNeut/Sg_s$        | \
         <>:<NNeut_0_0>             $NNeut_0_0$         | \
         <>:<NNeut_0_e>             $NNeut_0_e$         | \
         <>:<NNeut_0_e~ss>          $NNeut_0_e~ss$      | \
         <>:<NNeut_0_nen>           $NNeut_0_nen$       | \
         <>:<NNeut_0_s>             $NNeut_0_s$         | \
         <>:<NNeut_0_x>             $NNeut_0_x$         | \
         <>:<NNeut_es_$e>           $NNeut_es_\$e$      | \
         <>:<NNeut_es_$er>          $NNeut_es_\$er$     | \
         <>:<NNeut_es_$er~ss>       $NNeut_es_\$er~ss$  | \
         <>:<NNeut_es_e>            $NNeut_es_e$        | \
         <>:<NNeut_es_e~ss>         $NNeut_es_e~ss$     | \
         <>:<NNeut_es_en>           $NNeut_es_en$       | \
         <>:<NNeut_es_er>           $NNeut_es_er$       | \
         <>:<NNeut_es_es>           $NNeut_es_es$       | \
         <>:<NNeut_es_s>            $NNeut_es_s$        | \
         <>:<NNeut_s_$>             $NNeut_s_\$$        | \
         <>:<NNeut_s_$er>           $NNeut_s_\$er$      | \
         <>:<NNeut_s_0>             $NNeut_s_0$         | \
         <>:<NNeut_s_e>             $NNeut_s_e$         | \
         <>:<NNeut_s_en>            $NNeut_s_en$        | \
         <>:<NNeut_s_ien>           $NNeut_s_ien$       | \
         <>:<NNeut_s_n>             $NNeut_s_n$         | \
         <>:<NNeut_s_nen>           $NNeut_s_nen$       | \
         <>:<NNeut_s_s>             $NNeut_s_s$         | \
         <>:<NNeut_s_x>             $NNeut_s_x$         | \
         <>:<NNoGend/Pl_0>          $NNoGend/Pl_0$      | \
         <>:<NNoGend/Pl_x>          $NNoGend/Pl_x$      | \
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
         <>:<Ord>                   $Ord$               | \
         <>:<PInd-Invar>            $PInd-Invar$        | \
         <>:<Poss>                  $Poss$              | \
         <>:<Poss-er>               $Poss-er$           | \
         <>:<Poss/Wk>               $Poss/Wk$           | \
         <>:<Poss/Wk-er>            $Poss/Wk-er$        | \
         <>:<Postp>                 $Postp$             | \
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
         <>:<Prep>                  $Prep$              | \
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
         <>:<Ptcl-Adj>              $Ptcl-Adj$          | \
         <>:<Ptcl-Neg>              $Ptcl-Neg$          | \
         <>:<Ptcl-zu>               $Ptcl-zu$           | \
         <>:<Rel>                   $Rel$               | \
         <>:<Rel-welch>             $Rel-welch$         | \
         <>:<Roman>                 $Roman$             | \
         <>:<VAImpPl>               $VAImpPl$           | \
         <>:<VAImpSg>               $VAImpSg$           | \
         <>:<VAPastIndPl>           $VAPastIndPl$       | \
         <>:<VAPastIndSg>           $VAPastIndSg$       | \
         <>:<VAPastSubj2>           $VAPastSubj2$       | \
         <>:<VAPres1/3PlInd>        $VAPres1/3PlInd$    | \
         <>:<VAPres1/3SgSubj>       $VAPres1/3SgSubj$   | \
         <>:<VAPres1SgInd>          $VAPres1SgInd$      | \
         <>:<VAPres2PlInd>          $VAPres2PlInd$      | \
         <>:<VAPres2SgInd>          $VAPres2SgInd$      | \
         <>:<VAPres2SgSubj>         $VAPres2SgSubj$     | \
         <>:<VAPres3SgInd>          $VAPres3SgInd$      | \
         <>:<VAPresSubjPl>          $VAPresSubjPl$      | \
         <>:<VAPresSubjSg>          $VAPresSubjSg$      | \
         <>:<VInf+PPres>            $VInf+PPres$        | \
         <>:<VInf-en>               $VInf-en$           | \
         <>:<VInf-n>                $VInf-n$            | \
         <>:<VInf>                  $VInf$              | \
         <>:<VMPast>                $VMPast$            | \
         <>:<VMPast><>:<haben>      $VMPast+haben$      | \
         <>:<VMPast><>:<sein>       $VMPast+sein$       | \
         <>:<VMPastSubj>            $VMPastSubj$        | \
         <>:<VMPresPl>              $VMPresPl$          | \
         <>:<VMPresPl~ss>           $VMPresPl~ss$       | \
         <>:<VMPresSg>              $VMPresSg$          | \
         <>:<VMPresSg~ss>           $VMPresSg~ss$       | \
         <>:<VPastIndIrreg>         $VPastIndIrreg$     | \
         <>:<VPastIndReg>           $VPastIndReg$       | \
         <>:<VPastIndStr>           $VPastIndStr$       | \
         <>:<VPastSubjStr>          $VPastSubjStr$      | \
         <>:<VPPast>                $VPPast$            | \
         <>:<VPPast><>:<haben>      $VPPast+haben$      | \
         <>:<VPPast><>:<sein>       $VPPast+sein$       | \
         <>:<VPPres>                $VPPres$            | \
         <>:<VPresPlInd>            $VPresPlInd$        | \
         <>:<VPresSubj>             $VPresSubj$         | \
         <>:<VVPastIndReg>          $VVPastIndReg$      | \
         <>:<VVPastIndReg~ss>       $VVPastIndReg~ss$   | \
         <>:<VVPastIndStr>          $VVPastIndStr$      | \
         <>:<VVPastIndStr~ss>       $VVPastIndStr~ss$   | \
         <>:<VVPastStr>             $VVPastStr$         | \
         <>:<VVPastStr~ss>          $VVPastStr~ss$      | \
         <>:<VVPastSubjOld>         $VVPastSubjOld$     | \
         <>:<VVPastSubjReg>         $VVPastSubjReg$     | \
         <>:<VVPastSubjReg~ss>      $VVPastSubjReg~ss$  | \
         <>:<VVPastSubjStr>         $VVPastSubjStr$     | \
         <>:<VVPP-en>               $VVPP-en$           | \
         <>:<VVPP-en><>:<haben>     $VVPP-en+haben$     | \
         <>:<VVPP-en><>:<sein>      $VVPP-en+sein$      | \
         <>:<VVPP-t>                $VVPP-t$            | \
         <>:<VVPP-t><>:<haben>      $VVPP-t+haben$      | \
         <>:<VVPP-t><>:<sein>       $VVPP-t+sein$       | \
         <>:<VVPP-t~ss>             $VVPP-t~ss$         | \
         <>:<VVPP-t~ss><>:<haben>   $VVPP-t+haben~ss$   | \
         <>:<VVPP-t~ss><>:<sein>    $VVPP-t+sein~ss$    | \
         <>:<VVPres1+Imp>           $VVPres1+Imp$       | \
         <>:<VVPres1+Imp~ss>        $VVPres1+Imp~ss$    | \
         <>:<VVPres1>               $VVPres1$           | \
         <>:<VVPres1~ss>            $VVPres1~ss$        | \
         <>:<VVPres2+Imp>           $VVPres2+Imp$       | \
         <>:<VVPres2+Imp~ss>        $VVPres2+Imp~ss$    | \
         <>:<VVPres2+Imp0>          $VVPres2+Imp0$      | \
         <>:<VVPres2>               $VVPres2$           | \
         <>:<VVPres2~ss>            $VVPres2~ss$        | \
         <>:<VVPres2t>              $VVPres2t$          | \
         <>:<VVPres>                $VVPres$            | \
         <>:<VVPresPl>              $VVPresPl$          | \
         <>:<VVPresSg>              $VVPresSg$          | \
         <>:<VVReg-el/er>           $VVReg-el/er$       | \
         <>:<VVReg-el/er><>:<haben> $VVReg-el/er+haben$ | \
         <>:<VVReg-el/er><>:<sein>  $VVReg-el/er+sein$  | \
         <>:<VVReg>                 $VVReg$             | \
         <>:<VVReg><>:<haben>       $VVReg+haben$       | \
         <>:<VVReg><>:<sein>        $VVReg+sein$        | \
         <>:<VVReg~ss>              $VVReg~ss$          | \
         <>:<VVReg~ss><>:<haben>    $VVReg+haben~ss$    | \
         <>:<VVReg~ss><>:<sein>     $VVReg+sein~ss$     | \
         <>:<VVRegFin>              $VVRegFin$          | \
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

ALPHABET = [#char# #surface-trigger# #orth-trigger# #ss-trigger# #boundary-trigger# \
            <INS-E><Ge-Nom><UL><ge><zu> \
            <^Ax><^Px><^imp><^zz><^pp><^pl><^Gen><^Del>]

$=INFL$ = [#inflection#]:<>

$=AUX$ = [#auxiliary#]:<>

$InflFilter$ = (.* $=INFL$ $=AUX$ $=INFL$ $=AUX$ .*) | \
               (.* $=INFL$ $=INFL$ .*)
