% infl.fst
% Version 6.8
% Andreas Nolda 2024-07-22

% based on code from SMORLemma by Rico Sennrich
% which is in turn based on code from SMOR by Helmut Schmid

$SS$ = <>:<SS>


% nouns

% Frau; Mythos; Chaos
$NSg_0$ = {<Nom><Sg>}:{<SB>} | \
          {<Acc><Sg>}:{<SB>} | \
          {<Dat><Sg>}:{<SB>} | \
          {<Gen><Sg>}:{<SB>}

% Mensch, Menschen
$NSg_en$ = {<Nom><Sg>}:{<SB>}        | \
           {<Acc><Sg>}:{<SB>en}      | \
           {<Acc><Sg><NonSt>}:{<SB>} | \
           {<Dat><Sg>}:{<SB>en}      | \
           {<Dat><Sg><NonSt>}:{<SB>} | \ % cf. Duden-Grammatik (2016: § 333)
           {<Gen><Sg>}:{<SB>en}

% Nachbar, Nachbarn
$NSg_n$ = {<Nom><Sg>}:{<SB>}  | \
          {<Acc><Sg>}:{<SB>n} | \
          {<Dat><Sg>}:{<SB>n} | \
          {<Gen><Sg>}:{<SB>n}

% Haus, Hauses; Geist, Geist(e)s
$NSg_es$ = {<Nom><Sg>}:{<SB>}       | \
           {<Acc><Sg>}:{<SB>}       | \
           {<Dat><Sg>}:{<SB>}       | \
           {<Dat><Sg><Old>}:{<SB>e} | \ % cf. Duden-Grammatik (2016: § 317)
           {<Gen><Sg>}:{<SB>es<^Gen>}

% Opa, Opas; Klima, Klimas
$NSg_s$ = {<Nom><Sg>}:{<SB>} | \
          {<Acc><Sg>}:{<SB>} | \
          {<Dat><Sg>}:{<SB>} | \
          {<Gen><Sg>}:{<SB>s}

% Name, Namens; Buchstabe, Buchstabens
$NSg_ns$ = {<Nom><Sg>}:{<SB>}  | \
           {<Acc><Sg>}:{<SB>n} | \
           {<Dat><Sg>}:{<SB>n} | \
           {<Gen><Sg>}:{<SB>ns}

% Herz, Herzens
$NSg_ens$ = {<Nom><Sg>}:{<SB>}   | \
            {<Acc><Sg>}:{<SB>}   | \
            {<Dat><Sg>}:{<SB>en} | \
            {<Gen><Sg>}:{<SB>ens}

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
          {}:{<SB>e} $NPl_0$

$N_0_\$e$ =            $NSg_0$ | \
            {}:{<UL>e} $NPl_0$

$N_0_en$ =             $NSg_0$ | \
           {}:{<SB>en} $NPl_x$

$N_0_\$en$ =             $NSg_0$ | \
             {}:{<UL>en} $NPl_x$

$N_0_n$ =            $NSg_0$ | \
          {}:{<SB>n} $NPl_x$

$N_0_es$ =             $NSg_0$ | \
           {}:{<SB>es} $NPl_x$

$N_0_s$ =            $NSg_0$ | \
          {}:{<SB>s} $NPl_x$

$N_es_e$ =            $NSg_es$ | \
           {}:{<SB>e} $NPl_0$

$N_es_\$e$ =            $NSg_es$ | \
             {}:{<UL>e} $NPl_0$

$N_es_er$ =         $NSg_es$ | \
            {}:{er} $NPl_0$

$N_es_\$er$ =             $NSg_es$ | \
              {}:{<UL>er} $NPl_0$

$N_es_en$ =             $NSg_es$ | \
            {}:{<SB>en} $NPl_x$

$N_es_es$ =             $NSg_es$ | \
            {}:{<SB>es} $NPl_x$

$N_es_s$ =            $NSg_es$ | \
           {}:{<SB>s} $NPl_x$

$N_s_x$ = $NSg_s$ | \
          $NPl_x$

$N_s_\$x$ =           $NSg_s$ | \
            {}:{<UL>} $NPl_x$

$N_s_0$ = $NSg_s$ | \
          $NPl_0$

$N_s_\$$ =           $NSg_s$ | \
           {}:{<UL>} $NPl_0$

$N_s_e$ =            $NSg_s$ | \
          {}:{<SB>e} $NPl_0$

$N_s_\$e$ =              $NSg_s$ | \
            {<>}:{<UL>e} $NPl_0$

$N_s_er$ =             $NSg_s$ | \
           {}:{<SB>er} $NPl_x$

$N_s_\$er$ =               $NSg_s$ | \
             {<>}:{<UL>er} $NPl_0$

$N_s_en$ =             $NSg_s$ | \
           {}:{<SB>en} $NPl_x$

$N_s_n$ =            $NSg_s$ | \
          {}:{<SB>n} $NPl_x$

$N_s_s$ =            $NSg_s$ | \
          {}:{<SB>s} $NPl_x$

$N_en_en$ =             $NSg_en$ | \
            {}:{<SB>en} $NPl_x$

$N_n_n$ =            $NSg_n$ | \
          {}:{<SB>n} $NPl_x$


% masculine nouns

% Fiskus, Fiskus
$NMasc/Sg_0$ = {<+NN><Masc>}:{} $NSg_0$

% Abwasch, Abwasch(e)s; Glanz, Glanzes
$NMasc/Sg_es$ = {<+NN><Masc>}:{} $NSg_es$

% Hagel, Hagels; Adel, Adels
$NMasc/Sg_s$ = {<+NN><Masc>}:{} $NSg_s$

% Unglaube, Unglaubens
$NMasc/Sg_ns$ = {<+NN><Masc>}:{} $NSg_ns$

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

% Obelisk, Obelisk, Obelisken
$NMasc_0_en$ = {<+NN><Masc>}:{} $N_0_en$

% Kanon, Kanon, Kanones; Sandwich, Sandwich, Sandwiches (masculine)
$NMasc_0_es$ = {<+NN><Masc>}:{} $N_0_es$

% Embryo, Embryo, Embryonen (masculine)
$NMasc_0_nen$ = {<+NN><Masc>}:{}    $NSg_0$ | \
                {<+NN><Masc>}:{nen} $NPl_x$

% Intercity, Intercity, Intercitys
$NMasc_0_s$ = {<+NN><Masc>}:{} $N_0_s$

% Atlas, Atlas, Atlanten
$NMasc_0_as/anten$ = {<+NN><Masc>}:{}           $NSg_0$ | \
                     {<+NN><Masc>}:{<^pl>anten} $NPl_x$

% Carabiniere, Carabiniere, Carabinieri
$NMasc_0_e/i$ = {<+NN><Masc>}:{}       $NSg_0$ | \
                {<+NN><Masc>}:{<^pl>i} $NPl_x$

% Index, Index, Indizes
$NMasc_0_ex/izes$ = {<+NN><Masc>}:{}          $NSg_0$ | \
                    {<+NN><Masc>}:{<^pl>izes} $NPl_x$

% Saldo, Saldo, Salden
$NMasc_0_o/en$ = {<+NN><Masc>}:{}        $NSg_0$ | \
                 {<+NN><Masc>}:{<^pl>en} $NPl_x$

% Espresso, Espresso, Espressi
$NMasc_0_o/i$ = {<+NN><Masc>}:{}       $NSg_0$ | \
                {<+NN><Masc>}:{<^pl>i} $NPl_x$

% Kursus, Kursus, Kurse
$NMasc_0_us/e$ = {<+NN><Masc>}:{}       $NSg_0$ | \
                 {<+NN><Masc>}:{<^pl>e} $NPl_0$

% Virus, Virus, Viren; Mythos, Mythos, Mythen
$NMasc_0_us/en$ = {<+NN><Masc>}:{}        $NSg_0$ | \
                  {<+NN><Masc>}:{<^pl>en} $NPl_x$

% Kaktus, Kaktus, Kakteen
$NMasc_0_us/een$ = {<+NN><Masc>}:{}         $NSg_0$ | \
                   {<+NN><Masc>}:{<^pl>een} $NPl_x$

% Intimus, Intimus, Intimi
$NMasc_0_us/i$ = {<+NN><Masc>}:{}       $NSg_0$ | \
                 {<+NN><Masc>}:{<^pl>i} $NPl_x$

% Dinosaurus, Dinosaurus, Dinosaurier
$NMasc_0_us/ier$ = {<+NN><Masc>}:{}         $NSg_0$ | \
                   {<+NN><Masc>}:{<^pl>ier} $NPl_0$

% Larynx, Larynx, Laryngen
$NMasc_0_ynx/yngen$ = {<+NN><Masc>}:{}           $NSg_0$ | \
                      {<+NN><Masc>}:{<^pl>yngen} $NPl_x$

% Tag, Tag(e)s, Tage; Kodex, Kodexes, Kodexe
$NMasc_es_e$ = {<+NN><Masc>}:{} $N_es_e$

% Bus, Busses, Busse
$NMasc_es_e~ss$ = $SS$ $NMasc_es_e$

% Arzt, Arzt(e)s, Ärzte
$NMasc_es_\$e$ = {<+NN><Masc>}:{} $N_es_\$e$

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

% Bau, Bau(e)s, Bauten
$NMasc_es_ten$ = {<+NN><Masc>}:{}    $NSg_es$ | \
                 {<+NN><Masc>}:{ten} $NPl_x$

% Atlas, Atlasses, Atlanten
$NMasc_es_as/anten~ss$ = $SS$ {<+NN><Masc>}:{}           $NSg_es$ | \
                              {<+NN><Masc>}:{<^pl>anten} $NPl_x$

% Index, Indexes, Indizes
$NMasc_es_ex/izes$ = {<+NN><Masc>}:{}          $NSg_es$ | \
                     {<+NN><Masc>}:{<^pl>izes} $NPl_x$

% Virus, Virusses, Viren
$NMasc_es_us/en~ss$ = $SS$ {<+NN><Masc>}:{}        $NSg_es$ | \
                           {<+NN><Masc>}:{<^pl>en} $NPl_x$

% Kaktus, Kaktusses, Kakteen
$NMasc_es_us/een~ss$ = $SS$ {<+NN><Masc>}:{}         $NSg_es$ | \
                            {<+NN><Masc>}:{<^pl>een} $NPl_x$

% Intimus, Intimusse, Intimi
$NMasc_es_us/i~ss$ = $SS$ {<+NN><Masc>}:{}       $NSg_es$ | \
                          {<+NN><Masc>}:{<^pl>i} $NPl_x$

% Wagen, Wagens, Wagen
$NMasc_s_x$ = {<+NN><Masc>}:{} $N_s_x$

% Garten, Gartens, Gärten
$NMasc_s_\$x$ = {<+NN><Masc>}:{} $N_s_\$x$

% Engel, Engels, Engel; Dezember, Dezembers, Dezember
$NMasc_s_0$ = {<+NN><Masc>}:{} $N_s_0$

% Apfel, Apfels, Äpfel; Vater, Vaters, Väter; Schaden, Schadens, Schäden
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

% Kanon, Kanons, Kanones
$NMasc_s_es$ = {<+NN><Masc>}:{}   $NSg_s$ | \
               {<+NN><Masc>}:{es} $NPl_x$

% Muskel, Muskels, Muskeln; See, Sees, Seen
$NMasc_s_n$ = {<+NN><Masc>}:{} $N_s_n$

% Embryo, Embryos, Embryonen (masculine)
$NMasc_s_nen$ = {<+NN><Masc>}:{}    $NSg_s$ | \
                {<+NN><Masc>}:{nen} $NPl_x$

% Chef, Chefs, Chefs; Bankier, Bankiers, Bankiers
$NMasc_s_s$ = {<+NN><Masc>}:{} $N_s_s$

% Carabiniere, Carabinieres, Carabinieri
$NMasc_s_e/i$ = {<+NN><Masc>}:{}       $NSg_s$ | \
                {<+NN><Masc>}:{<^pl>i} $NPl_x$

% Saldo, Saldos, Salden
$NMasc_s_o/en$ = {<+NN><Masc>}:{}        $NSg_s$ | \
                 {<+NN><Masc>}:{<^pl>en} $NPl_x$

% Espresso, Espressos, Espressi
$NMasc_s_o/i$ = {<+NN><Masc>}:{}       $NSg_s$ | \
                {<+NN><Masc>}:{<^pl>i} $NPl_x$

% Fels, Felsen, Felsen; Mensch, Menschen, Menschen
$NMasc_en_en$ = {<+NN><Masc>}:{} $N_en_en$

% Affe, Affen, Affen; Bauer, Bauern, Bauern
$NMasc_n_n$ = {<+NN><Masc>}:{} $N_n_n$

% Name, Namens, Namen; Buchstabe, Buchstabens, Buchstaben
$NMasc_ns_n$ = {<+NN><Masc>}:{}  $NSg_ns$ | \
               {<+NN><Masc>}:{n} $NPl_x$

% Schade, Schadens, Schäden
$NMasc_ns_\$n$ = {<+NN><Masc>}:{}      $NSg_ns$ | \
                 {<+NN><Masc>}:{<UL>n} $NPl_x$

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
$NNeut/Sg_es~ss$ = $SS$ {<+NN><Neut>}:{} $NSg_es$

% Abitur, Abiturs
$NNeut/Sg_s$ = {<+NN><Neut>}:{} $NSg_s$

% Viecher (suppletive plural)
$NNeut/Pl_0$ = {<+NN><Neut>}:{} $NPl_0$

% Relais, Relais, Relais
$NNeut_0_x$ = {<+NN><Neut>}:{} $N_0_x$

% Gefolge, Gefolge, Gefolge
$NNeut_0_0$ = {<+NN><Neut>}:{} $N_0_0$

% Bakschisch, Bakschisch, Bakschische
$NNeut_0_e$ = {<+NN><Neut>}:{} $N_0_e$

% Rhinozeros, Rhinozeros, Rhinozerosse
$NNeut_0_e~ss$ = $SS$ $NNeut_0_e$

% Remis, Remis, Remisen
$NNeut_0_en$ = {<+NN><Neut>}:{} $N_0_en$

% Sandwich, Sandwich, Sandwiches (neuter)
$NNeut_0_es$ = {<+NN><Neut>}:{} $N_0_es$

% Embryo, Embryo, Embryonen (neuter)
$NNeut_0_nen$ = {<+NN><Neut>}:{}    $NSg_0$ | \
                {<+NN><Neut>}:{nen} $NPl_x$

% College, College, Colleges
$NNeut_0_s$ = {<+NN><Neut>}:{} $N_0_s$

% Komma, Komma, Kommata
$NNeut_0_a/ata$ = {<+NN><Neut>}:{}   $NSg_0$ | \
                  {<+NN><Neut>}:{ta} $NPl_x$

% Dogma, Dogma, Dogmen
$NNeut_0_a/en$ = {<+NN><Neut>}:{}        $NSg_0$ | \
                 {<+NN><Neut>}:{<^pl>en} $NPl_x$

% Stimulans, Stimulans, Stimulanzien
$NNeut_0_ans/anzien$ = {<+NN><Neut>}:{}            $NSg_0$ | \
                       {<+NN><Neut>}:{<^pl>anzien} $NPl_x$

% Ricercare, Ricercare, Ricercari
$NNeut_0_e/i$ = {<+NN><Neut>}:{}       $NSg_0$ | \
                {<+NN><Neut>}:{<^pl>i} $NPl_x$

% Examen, Examen, Examina
$NNeut_0_en/ina$ = {<+NN><Neut>}:{}         $NSg_0$ | \
                   {<+NN><Neut>}:{<^pl>ina} $NPl_x$

% Reagens, Reagens, Reagenzien
$NNeut_0_ens/enzien$ = {<+NN><Neut>}:{}            $NSg_0$ | \
                       {<+NN><Neut>}:{<^pl>enzien} $NPl_x$

% Konto, Konto, Konten
$NNeut_0_o/en$ = {<+NN><Neut>}:{}        $NSg_0$ | \
                 {<+NN><Neut>}:{<^pl>en} $NPl_x$

% Intermezzo, Intermezzo, Intermezzi
$NNeut_0_o/i$ = {<+NN><Neut>}:{}       $NSg_0$ | \
                {<+NN><Neut>}:{<^pl>i} $NPl_x$

% Oxymoron, Oxymoron, Oxymora
$NNeut_0_on/a$ = {<+NN><Neut>}:{}       $NSg_0$ | \
                 {<+NN><Neut>}:{<^pl>a} $NPl_x$

% Stadion, Stadion, Stadien
$NNeut_0_on/en$ = {<+NN><Neut>}:{}        $NSg_0$ | \
                  {<+NN><Neut>}:{<^pl>en} $NPl_x$

% Aktivum, Aktivum, Aktiva
$NNeut_0_um/a$ = {<+NN><Neut>}:{}       $NSg_0$ | \
                 {<+NN><Neut>}:{<^pl>a} $NPl_x$

% Museum, Museum, Museen
$NNeut_0_um/en$ = {<+NN><Neut>}:{}        $NSg_0$ | \
                  {<+NN><Neut>}:{<^pl>en} $NPl_x$

% Virus, Virus, Viren; Epos, Epos, Epen
$NNeut_0_us/en$ = {<+NN><Neut>}:{}        $NSg_0$ | \
                  {<+NN><Neut>}:{<^pl>en} $NPl_x$

% Genus, Genus, Genera
$NNeut_0_us/era$ = {<+NN><Neut>}:{}         $NSg_0$ | \
                   {<+NN><Neut>}:{<^pl>era} $NPl_x$

% Tempus, Tempus, Tempora
$NNeut_0_us/ora$ = {<+NN><Neut>}:{}         $NSg_0$ | \
                   {<+NN><Neut>}:{<^pl>ora} $NPl_x$

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

% Bett, Bett(e)s, Betten
$NNeut_es_en$ = {<+NN><Neut>}:{} $N_es_en$

% Match, Match(e)s, Matches
$NNeut_es_es$ = {<+NN><Neut>}:{} $N_es_es$

% Tablett, Tablett(e)s, Tabletts
$NNeut_es_s$ = {<+NN><Neut>}:{} $N_es_s$

% Indiz, Indizes, Indizien
$NNeut_es_ien$ = {<+NN><Neut>}:{}    $NSg_es$ | \
                 {<+NN><Neut>}:{ien} $NPl_x$

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

% Embryo, Embryos, Embryonen (neuter)
$NNeut_s_nen$ = {<+NN><Neut>}:{}    $NSg_s$ | \
                {<+NN><Neut>}:{nen} $NPl_x$

% Adverb, Adverbs, Adverbien
$NNeut_s_ien$ = {<+NN><Neut>}:{}    $NSg_s$ | \
                {<+NN><Neut>}:{ien} $NPl_x$

% Sofa, Sofas, Sofas; College, Colleges, Colleges
$NNeut_s_s$ = {<+NN><Neut>}:{} $N_s_s$

% Komma, Kommas, Kommata
$NNeut_s_a/ata$ = {<+NN><Neut>}:{}   $NSg_s$ | \
                  {<+NN><Neut>}:{ta} $NPl_x$

% Dogma, Dogmas, Dogmen
$NNeut_s_a/en$ = {<+NN><Neut>}:{}        $NSg_s$ | \
                 {<+NN><Neut>}:{<^pl>en} $NPl_x$

% Ricercare, Ricercares, Ricercari
$NNeut_s_e/i$ = {<+NN><Neut>}:{}       $NSg_s$ | \
                {<+NN><Neut>}:{<^pl>i} $NPl_x$

% Examen, Examens, Examina
$NNeut_s_en/ina$ = {<+NN><Neut>}:{}         $NSg_s$ | \
                   {<+NN><Neut>}:{<^pl>ina} $NPl_x$

% Konto, Kontos, Konten
$NNeut_s_o/en$ = {<+NN><Neut>}:{}        $NSg_s$ | \
                 {<+NN><Neut>}:{<^pl>en} $NPl_x$

% Intermezzo, Intermezzos, Intermezzi
$NNeut_s_o/i$ = {<+NN><Neut>}:{}       $NSg_s$ | \
                {<+NN><Neut>}:{<^pl>i} $NPl_x$

% Oxymoron, Oxymorons, Oxymora
$NNeut_s_on/a$ = {<+NN><Neut>}:{}       $NSg_s$ | \
                 {<+NN><Neut>}:{<^pl>a} $NPl_x$

% Stadion, Stadions, Stadien
$NNeut_s_on/en$ = {<+NN><Neut>}:{}        $NSg_s$ | \
                  {<+NN><Neut>}:{<^pl>en} $NPl_x$

% Aktivum, Aktivums, Aktiva
$NNeut_s_um/a$ = {<+NN><Neut>}:{}       $NSg_s$ | \
                 {<+NN><Neut>}:{<^pl>a} $NPl_x$

% Museum, Museums, Museen
$NNeut_s_um/en$ = {<+NN><Neut>}:{}        $NSg_s$ | \
                  {<+NN><Neut>}:{<^pl>en} $NPl_x$

% Herz, Herzens, Herzen
$NNeut_ens_en$ = {<+NN><Neut>}:{}   $NSg_ens$ | \
                 {<+NN><Neut>}:{en} $NPl_x$

% Innere(s)
$NNeut-Inner$ = {<+NN><Neut><Nom><Sg><St>}:{<SB>es} | \
                {<+NN><Neut><Acc><Sg><St>}:{<SB>es} | \
                {<+NN><Neut><Dat><Sg><St>}:{<SB>em} | \
                {<+NN><Neut><Gen><Sg><St>}:{<SB>en} | \
                {<+NN><Neut><Gen><Sg><St>}:{<SB>n}  | \
                {<+NN><Neut><Nom><Sg><Wk>}:{<SB>e}  | \
                {<+NN><Neut><Acc><Sg><Wk>}:{<SB>e}  | \
                {<+NN><Neut><Dat><Sg><Wk>}:{<SB>en} | \
                {<+NN><Neut><Dat><Sg><Wk>}:{<SB>n}  | \
                {<+NN><Neut><Gen><Sg><Wk>}:{<SB>en} | \
                {<+NN><Neut><Gen><Sg><Wk>}:{<SB>n}

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

% Wut, Wut
$NFem/Sg_0$ = {<+NN><Fem>}:{} $NSg_0$

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

% Frau, Frau, Frauen; Arbeit, Arbeit, Arbeiten
$NFem_0_en$ = {<+NN><Fem>}:{} $N_0_en$

% Werkstatt, Werkstatt, Werkstätten
$NFem_0_\$en$ = {<+NN><Fem>}:{} $N_0_\$en$

% Hilfe, Hilfe, Hilfen; Tafel, Tafel, Tafeln
$NFem_0_n$ = {<+NN><Fem>}:{} $N_0_n$

% Smartwatch, Smartwatch, Smartwatches
$NFem_0_es$ = {<+NN><Fem>}:{} $N_0_es$

% Oma, Oma, Omas
$NFem_0_s$ = {<+NN><Fem>}:{} $N_0_s$

% Algebra, Algebra, Algebren; Firma, Firma, Firmen
$NFem_0_a/en$ = {<+NN><Fem>}:{}        $NSg_0$ | \
                {<+NN><Fem>}:{<^pl>en} $NPl_x$

% Phalanx, Phalanx, Phalangen
$NFem_0_anx/angen$ = {<+NN><Fem>}:{}           $NSg_0$ | \
                     {<+NN><Fem>}:{<^pl>angen} $NPl_x$

% Minestrone, Minestrone, Minestroni
$NFem_0_e/i$ = {<+NN><Fem>}:{}       $NSg_0$ | \
               {<+NN><Fem>}:{<^pl>i} $NPl_x$

% Lex, Lex, Leges
$NFem_0_ex/eges$ = {<+NN><Fem>}:{}          $NSg_0$ | \
                   {<+NN><Fem>}:{<^pl>eges} $NPl_x$

% Basis, Basis, Basen
$NFem_0_is/en$ = {<+NN><Fem>}:{}        $NSg_0$ | \
                 {<+NN><Fem>}:{<^pl>en} $NPl_x$

% Neuritis, Neuritis, Neuritiden
$NFem_0_is/iden$ = {<+NN><Fem>}:{}          $NSg_0$ | \
                   {<+NN><Fem>}:{<^pl>iden} $NPl_x$

% Matrix, Matrix, Matrizen
$NFem_0_ix/izen$ = {<+NN><Fem>}:{}          $NSg_0$ | \
                   {<+NN><Fem>}:{<^pl>izen} $NPl_x$

% Radix, Radix, Radizes
$NFem_0_ix/izes$ = {<+NN><Fem>}:{}          $NSg_0$ | \
                   {<+NN><Fem>}:{<^pl>izes} $NPl_x$

% Freundin, Freundin, Freundinnen
$NFem-in$ = {<+NN><Fem>}:{}    $NSg_0$ | \
            {<+NN><Fem>}:{nen} $NPl_x$

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

$NameMasc_0$ = {<+NPROP><Masc>}:{} $NSg_0$

% Andreas, Andreas'
$NameMasc_apos$ = {<+NPROP><Masc>}:{} $NSg_0$ | \
                  {<+NPROP><Masc><Gen><Sg>}:{’}

$NameMasc_es$ = {<+NPROP><Masc>}:{} $NSg_es$

$NameMasc_s$ = {<+NPROP><Masc>}:{} $NSg_s$

$NameNeut_0$ = {<+NPROP><Neut>}:{} $NSg_0$

% Paris, Paris'
$NameNeut_apos$ = {<+NPROP><Neut>}:{} $NSg_0$ | \
                  {<+NPROP><Neut><Gen><Sg>}:{’}

$NameNeut_es$ = {<+NPROP><Neut>}:{} $NSg_es$

$NameNeut_s$ = {<+NPROP><Neut>}:{} $NSg_s$

$NameFem_0$ = {<+NPROP><Fem>}:{} $NSg_0$

% Felicitas, Felicitas'
$NameFem_apos$ = {<+NPROP><Fem>}:{} $NSg_0$ | \
                 {<+NPROP><Fem><Gen><Sg>}:{’}

$NameFem_s$ = {<+NPROP><Fem>}:{} $NSg_s$

$NameNoGend/Pl_x$ = {<+NPROP><NoGend>}:{} $NPl_x$

$NameNoGend/Pl_0$ = {<+NPROP><NoGend>}:{} $NPl_0$

% family names ending in -s, -z
$Name-Fam_0$ = {<+NPROP><NoGend>}:{}    $NSg_0$ | \
               {<+NPROP><NoGend>}:{ens} $NPl_x$

% family names
$Name-Fam_s$ = {<+NPROP><NoGend>}:{}  $NSg_s$ | \
               {<+NPROP><NoGend>}:{s} $NPl_x$


% adjectives

$AdjInflSuff$ = {<Attr/Subst><Masc><Nom><Sg><St>}:{er}   | \
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
                {<Attr/Subst><NoGend><Acc><Pl><Wk>}:{en} | \
                {<Attr/Subst><NoGend><Dat><Pl><Wk>}:{en} | \
                {<Attr/Subst><NoGend><Gen><Pl><Wk>}:{en}

$AdjInflSuff-n$ = {<Attr/Subst><Masc><Acc><Sg><St>}:{n}   | \
                  {<Attr/Subst><Masc><Gen><Sg><St>}:{n}   | \
                  {<Attr/Subst><Neut><Gen><Sg><St>}:{n}   | \
                  {<Attr/Subst><NoGend><Dat><Pl><St>}:{n} | \
                  {<Attr/Subst><Masc><Acc><Sg><Wk>}:{n}   | \
                  {<Attr/Subst><Masc><Dat><Sg><Wk>}:{n}   | \
                  {<Attr/Subst><Masc><Gen><Sg><Wk>}:{n}   | \
                  {<Attr/Subst><Neut><Dat><Sg><Wk>}:{n}   | \
                  {<Attr/Subst><Neut><Gen><Sg><Wk>}:{n}   | \
                  {<Attr/Subst><Fem><Dat><Sg><Wk>}:{n}    | \
                  {<Attr/Subst><Fem><Gen><Sg><Wk>}:{n}    | \
                  {<Attr/Subst><NoGend><Nom><Pl><Wk>}:{n} | \
                  {<Attr/Subst><NoGend><Acc><Pl><Wk>}:{n} | \
                  {<Attr/Subst><NoGend><Dat><Pl><Wk>}:{n} | \
                  {<Attr/Subst><NoGend><Gen><Pl><Wk>}:{n}

$AdjInflSuff-m$ = {<Attr/Subst><Masc><Dat><Sg><St>}:{m} | \
                  {<Attr/Subst><Neut><Dat><Sg><St>}:{m}

% lila; klasse
$AdjPos0$ = {<+ADJ><Pos><Pred/Adv>}:{} | \
            {<+ADJ><Pos><Attr><Invar>}:{}

% viel; wenig
$AdjPos0-viel$ = {<+ADJ><Pos><Pred/Adv>}:{} | \
                 {<+ADJ><Pos><Attr/Subst><Invar>}:{}

% innen; hoch
$AdjPosPred$ = {<+ADJ><Pos><Pred/Adv>}:{}

% zig
$AdjPos0Attr$ = {<+ADJ><Pos><Attr><Invar>}:{}

% Berliner ('related to Berlin')
$AdjPos0AttrSubst$ = {<+ADJ><Pos><Attr/Subst><Invar>}:{}

% derartig; famos; bloß
$AdjPos$ = {<+ADJ><Pos><Pred/Adv>}:{<SB>} | \
           {<+ADJ><Pos>}:{<SB>} $AdjInflSuff$

% vorig-; hoh-
$AdjPosAttr$ = {<+ADJ><Pos>}:{<SB>} $AdjInflSuff$

% ander-; ober-
$AdjPosAttr-er$ = $AdjPosAttr$                         | \
                  {}:{<^Ax>} $AdjPosAttr$              | \
                  {<+ADJ><Pos>}:{<SB>} $AdjInflSuff-n$ | \
                  {<+ADJ><Pos>}:{<SB>} $AdjInflSuff-m$

% besser; höher
$AdjComp$ = {<+ADJ><Comp><Pred/Adv>}:{er}       | \
            {<+ADJ><Comp>}:{er} $AdjInflSuff$

% mehr; weniger
$AdjComp0-mehr$ = {<+ADJ><Comp><Pred/Adv>}:{} | \
                  {<+ADJ><Comp><Attr/Subst><Invar>}:{}

% besten; höchsten
$AdjSup$ = {<+ADJ><Sup><Pred/Adv>}:{sten} | \
           {<+ADJ><Sup>}:{st} $AdjInflSuff$

% allerbesten; allerhöchsten
$AdjSup-aller$ = {<+ADJ><Sup><Pred/Adv>}:{sten} | \
                 {<+ADJ><Sup>}:{st} $AdjInflSuff$

% obersten
$AdjSupAttr$ = {<+ADJ><Sup>}:{st} $AdjInflSuff$

% faul, fauler, faulsten
$Adj_0$ =           $AdjPos$  | \
          {}:{<SB>} $AdjComp$ | \
          {}:{<SB>} $AdjSup$

% bunt, bunter, buntesten
$Adj_e$ =            $AdjPos$  | \
          {}:{<SB>}  $AdjComp$ | \
          {}:{<SB>e} $AdjSup$

% warm, wärmer, wärmsten
$Adj_\$$ =           $AdjPos$  | \
           {}:{<UL>} $AdjComp$ | \
           {}:{<UL>} $AdjSup$

% kalt, kälter, kältesten
$Adj_\$e$ =            $AdjPos$  | \
            {}:{<UL>}  $AdjComp$ | \
            {}:{<UL>e} $AdjSup$

% dunkel, dunkler, dunkelsten
$Adj-el_0$ = {}:{<^Ax>} $Adj_0$                              | \
             {<+ADJ><Pos>}:{<SB>} $AdjInflSuff-n$ {<Old>}:{} | \ % cf. Duden-Grammatik (2016: § 494)
             {<+ADJ><Pos>}:{<SB>} $AdjInflSuff-m$ {<Old>}:{}     % cf. Duden-Grammatik (2016: § 494)

% dunkel, dünkler, dünkelsten (regional variant)
$Adj-el_\$$ = {}:{<^Ax>} $Adj_\$$                             | \
              {<+ADJ><Pos>}:{<SB>} $AdjInflSuff-n$ {<Old>}:{} | \ % cf. Duden-Grammatik (2016: § 494)
              {<+ADJ><Pos>}:{<SB>} $AdjInflSuff-m$ {<Old>}:{}     % cf. Duden-Grammatik (2016: § 494)

% finster, finst(e)rer, finstersten
$Adj-er_0$ = $Adj_0$                                         | \
             {}:{<^Ax>} $Adj_0$                              | \
             {<+ADJ><Pos>}:{<SB>} $AdjInflSuff-n$ {<Old>}:{} | \ % cf. Duden-Grammatik (2016: § 494)
             {<+ADJ><Pos>}:{<SB>} $AdjInflSuff-m$ {<Old>}:{}     % cf. Duden-Grammatik (2016: § 494)

% trocken, trock(e)ner, trockensten
$Adj-en_0$ = $Adj_0$ | \
             {}:{<^Ax>} $Adj_0$

% deutsch; [das] Deutsch
$Adj-Lang$ = $Adj_0$ | \
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
            {[<Attr><Subst>]<Masc><Acc><Sg><St>}:{en}   | \
            {[<Attr><Subst>]<Masc><Dat><Sg><St>}:{em}   | \
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

$DemSuff-alldem$ = {<Subst><Neut><Dat><Sg><St>}:{em}

$DemSuff0$ = {[<Attr><Subst>]<Invar>}:{}

$ArtDef-der+DemMascSuff$ = {<Nom><Sg><Wk>}:{e}

$ArtDef-den+DemMascSuff$ = {<Acc><Sg><Wk>}:{en}

$ArtDef-dem+DemMascSuff$ = {<Dat><Sg><Wk>}:{en}

$ArtDef-des+DemMascSuff$ = {<Gen><Sg><Wk>}:{en}

$ArtDef-das+DemNeutSuff$ = {<Nom><Sg><Wk>}:{e} | \
                           {<Acc><Sg><Wk>}:{e}

$ArtDef-dem+DemNeutSuff$ = {<Dat><Sg><Wk>}:{en}

$ArtDef-des+DemNeutSuff$ = {<Gen><Sg><Wk>}:{en}

$ArtDef-die+DemFemSuff$ = {<Nom><Sg><Wk>}:{e} | \
                          {<Acc><Sg><Wk>}:{e}

$ArtDef-der+DemFemSuff$ = {<Dat><Sg><Wk>}:{en} | \
                          {<Gen><Sg><Wk>}:{en}

$ArtDef-die+DemNoGendSuff$ = {<Nom><Pl><Wk>}:{en} | \
                             {<Acc><Pl><Wk>}:{en}

$ArtDef-den+DemNoGendSuff$ = {<Dat><Pl><Wk>}:{en}

$ArtDef-der+DemNoGendSuff$ = {<Gen><Pl><Wk>}:{en}

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

$IProSuff-unsereiner$ = {<Nom><Sg>}:{er} | \ % cf. Duden-Grammatik (2016: § 433)
                        {<Acc><Sg>}:{en} | \
                        {<Dat><Sg>}:{em}

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
                     {<Gen><Pl><NonSt>}:{er<^Px><SB>er} % cf. Duden-Grammatik (2016: § 363)

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
$ArtDef$ = {<+ART><Def>}:{<SB>} $ArtDefSuff$

% der, die, das (relative pronoun)
$Rel$ = {<+REL>}:{<SB>} $RelSuff$

% der, die, das (demonstrative pronoun)
$DemDef$ = {<+DEM>}:{<SB>} $DemDefSuff$

% dieser, diese, dieses/dies
$Dem-dies$ = {<+DEM>}:{<SB>} $DemSuff-dies$

% solcher, solche, solches, solch
$Dem-solch$ = {<+DEM>}:{<SB>} $DemSuff-solch$

% alldem, alledem
$Dem-alldem$ = {<+DEM>}:{<SB>} $DemSuff-alldem$

% jener, jene, jenes
$Dem$ = {<+DEM>}:{<SB>} $DemSuff$

% derlei
$Dem0$ = {<+DEM>}:{<SB>} $DemSuff0$

% derjenige; derselbe
$ArtDef-der+DemMasc$ = {<+DEM>[<Attr><Subst>]<Masc>}:{<SB>} $ArtDef-der+DemMascSuff$

% denjenigen; denselben (masculine)
$ArtDef-den+DemMasc$ = {<+DEM>[<Attr><Subst>]<Masc>}:{<SB>} $ArtDef-den+DemMascSuff$

% demjenigen; demselben (masculine)
$ArtDef-dem+DemMasc$ = {<+DEM>[<Attr><Subst>]<Masc>}:{<SB>} $ArtDef-dem+DemMascSuff$

% desjenigen; desselben (masculine)
$ArtDef-des+DemMasc$ = {<+DEM>[<Attr><Subst>]<Masc>}:{<SB>} $ArtDef-des+DemMascSuff$

% dasjenige; dasselbe
$ArtDef-das+DemNeut$ = {<+DEM>[<Attr><Subst>]<Neut>}:{<SB>} $ArtDef-das+DemNeutSuff$

% demjenigen; demselben (neuter)
$ArtDef-dem+DemNeut$ = {<+DEM>[<Attr><Subst>]<Neut>}:{<SB>} $ArtDef-dem+DemNeutSuff$

% desjenigen; desselben (neuter)
$ArtDef-des+DemNeut$ = {<+DEM>[<Attr><Subst>]<Neut>}:{<SB>} $ArtDef-des+DemNeutSuff$

% diejenige; dieselbe
$ArtDef-die+DemFem$ = {<+DEM>[<Attr><Subst>]<Fem>}:{<SB>} $ArtDef-die+DemFemSuff$

% derjenigen; derselben (feminine)
$ArtDef-der+DemFem$ = {<+DEM>[<Attr><Subst>]<Fem>}:{<SB>} $ArtDef-der+DemFemSuff$

% diejenigen; dieselben
$ArtDef-die+DemNoGend$ = {<+DEM>[<Attr><Subst>]<NoGend>}:{<SB>} $ArtDef-die+DemNoGendSuff$

% denjenigen; denselben (plural)
$ArtDef-den+DemNoGend$ = {<+DEM>[<Attr><Subst>]<NoGend>}:{<SB>} $ArtDef-den+DemNoGendSuff$

% derjenigen; derselben (plural)
$ArtDef-der+DemNoGend$ = {<+DEM>[<Attr><Subst>]<NoGend>}:{<SB>} $ArtDef-der+DemNoGendSuff$

% welcher, welche, welches, welch (interrogative pronoun)
$W-welch$ = {<+WPRO>}:{<SB>} $WSuff-welch$

% welcher, welche, welches, welch (relative pronoun)
$Rel-welch$ = {<+REL>}:{<SB>} $RelSuff-welch$

% welcher, welche, welches (indefinite pronoun)
$Indef-welch$ = {<+INDEF>}:{<SB>} $IndefSuff-welch$

% irgendwelcher, irgendwelche, irgendwelches (indefinite pronoun)
$Indef-irgendwelch$ = {<+INDEF>}:{<SB>} $IndefSuff-irgendwelch$

% aller, alle, alles
$Indef-all$ = {<+INDEF>}:{<SB>} $IndefSuff-all$

% jeder, jede, jedes
$Indef-jed$ = {<+INDEF>}:{<SB>} $IndefSuff-jed$

% jeglicher, jegliche, jegliches
$Indef-jeglich$ = {<+INDEF>}:{<SB>} $IndefSuff-jeglich$

% sämtlicher, sämtliche, sämtliches
$Indef-saemtlich$ = {<+INDEF>}:{<SB>} $IndefSuff-saemtlich$

% beide, beides
$Indef-beid$ = {<+INDEF>}:{<SB>} $IndefSuff-beid$

% einiger, einige, einiges
$Indef-einig$ = {<+INDEF>}:{<SB>} $IndefSuff-einig$

% mancher, manche, manches, manch
$Indef-manch$ = {<+INDEF>}:{<SB>} $IndefSuff-manch$

% mehrere, mehreres
$Indef-mehrer$ = {<+INDEF>}:{<SB>} $IndefSuff-mehrer$

% genug
$Indef0$ = {<+INDEF>}:{<SB>} $IndefSuff0$

% ein, eine (article)
$ArtIndef$ = {<+ART><Indef>}:{<SB>} $ArtIndefSuff$

% 'n, 'ne (clitic article)
$ArtIndef-n$ = {<+ART><Indef>}:{<SB>} $ArtIndefAttrSuff$ {<NonSt>}:{} % cf. Duden-Grammatik (2016: § 448)

% einer, eine, eines (indefinite pronoun)
$Indef-ein$ = {<+INDEF>}:{<SB>} $IndefSuff-ein$

% irgendein, irgendeine
$Indef-irgendein$ = {<+INDEF>}:{<SB>} $ArtIndefSuff$

% kein, keine (article)
$ArtNeg$ = {<+ART><Neg>}:{<SB>} $ArtNegSuff$

% keiner, keine, keines (indefinite pronoun)
$Indef-kein$ = {<+INDEF>}:{<SB>} $IndefSuff-kein$

% mein, meine
$Poss$ = {<+POSS>}:{<SB>} $PossSuff$

% unser, unsere/unsre
$Poss-er$ = {<+POSS>}:{<^Px><SB>} $PossSuff$

% (die) meinigen/Meinigen
$Poss/Wk$ = {<+POSS>}:{<SB>} $PossSuff/Wk$

% unserige/unsrige
$Poss/Wk-er$ = {<+POSS>}:{<^Px><SB>} $PossSuff/Wk$

% etwas
$IProNeut$ = {<+INDEF><Neut>}:{<SB>} $IProSuff0$

% jemand
$IProMasc$ = {<+INDEF><Masc>}:{<SB>} $IProSuff$

% jedermann
$IPro-jedermann$ = {<+INDEF><Masc>}:{<SB>} $IProSuff-jedermann$

% man
$IPro-man$ = {<+INDEF><Masc>}:{<SB>} $IProSuff-man$

% unsereiner
$IPro-unsereiner$ = {<+INDEF><Masc>}:{<SB>} $IProSuff-unsereiner$

% unsereins
$IPro-unsereins$ = {<+INDEF><Masc>}:{<SB>} $IProSuff0$

% ich
$PPro1NomSg$ = {<+PPRO><Pers><1>}:{<SB>} $PProNomSgSuff$

% mich (irreflexive)
$PPro1AccSg$ = {<+PPRO><Pers><1>}:{<SB>} $PProAccSgSuff$

% mir (irreflexive)
$PPro1DatSg$ = {<+PPRO><Pers><1>}:{<SB>} $PProDatSgSuff$

% meiner, mein
$PPro1GenSg$ = {<+PPRO><Pers><1>}:{<SB>} $PProGenSgSuff$

% du
$PPro2NomSg$ = {<+PPRO><Pers><2>}:{<SB>} $PProNomSgSuff$

% dich (irreflexive)
$PPro2AccSg$ = {<+PPRO><Pers><2>}:{<SB>} $PProAccSgSuff$

% dir (irreflexive)
$PPro2DatSg$ = {<+PPRO><Pers><2>}:{<SB>} $PProDatSgSuff$

% deiner, dein
$PPro2GenSg$ = {<+PPRO><Pers><2>}:{<SB>} $PProGenSgSuff$

% sie (singular)
$PProFemNomSg$ = {<+PPRO><Pers><3><Fem>}:{<SB>} $PProNomSgSuff$

% sie (singular)
$PProFemAccSg$ = {<+PPRO><Pers><3><Fem>}:{<SB>} $PProAccSgSuff$

% ihr
$PProFemDatSg$ = {<+PPRO><Pers><3><Fem>}:{<SB>} $PProDatSgSuff$

% ihrer, ihr
$PProFemGenSg$ = {<+PPRO><Pers><3><Fem>}:{<SB>} $PProGenSgSuff$

% er
$PProMascNomSg$ = {<+PPRO><Pers><3><Masc>}:{<SB>} $PProNomSgSuff$

% ihn
$PProMascAccSg$ = {<+PPRO><Pers><3><Masc>}:{<SB>} $PProAccSgSuff$

% ihm
$PProMascDatSg$ = {<+PPRO><Pers><3><Masc>}:{<SB>} $PProDatSgSuff$

% seiner, sein
$PProMascGenSg$ = {<+PPRO><Pers><3><Masc>}:{<SB>} $PProGenSgSuff$

% es
$PProNeutNomSg$ = {<+PPRO><Pers><3><Neut>}:{<SB>} $PProNomSgSuff$

% 's (clitic pronoun)
$PProNeutNomSg-s$ = $PProNeutNomSg$ {<NonSt>}:{}

% es
$PProNeutAccSg$ = {<+PPRO><Pers><3><Neut>}:{<SB>} $PProAccSgSuff$

% 's (clitic pronoun)
$PProNeutAccSg-s$ = $PProNeutAccSg$ {<NonSt>}:{}

% ihm
$PProNeutDatSg$ = {<+PPRO><Pers><3><Neut>}:{<SB>} $PProDatSgSuff$

% seiner
$PProNeutGenSg$ = {<+PPRO><Pers><3><Neut>}:{<SB>} $PProGenSgSuff$

% wir
$PPro1NomPl$ = {<+PPRO><Pers><1>}:{<SB>} $PProNomPlSuff$

% uns (irreflexive)
$PPro1AccPl$ = {<+PPRO><Pers><1>}:{<SB>} $PProAccPlSuff$

% uns (irreflexive)
$PPro1DatPl$ = {<+PPRO><Pers><1>}:{<SB>} $PProDatPlSuff$

% unser, unserer/unsrer
$PPro1GenPl$ = {<+PPRO><Pers><1>}:{<SB>} $PProGenPlSuff-er$

% ihr
$PPro2NomPl$ = {<+PPRO><Pers><2>}:{<SB>} $PProNomPlSuff$

% euch (irreflexive)
$PPro2AccPl$ = {<+PPRO><Pers><2>}:{<SB>} $PProAccPlSuff$

% euch (irreflexive)
$PPro2DatPl$ = {<+PPRO><Pers><2>}:{<SB>} $PProDatPlSuff$

% euer, eurer
$PPro2GenPl$ = {<+PPRO><Pers><2>}:{<SB>} $PProGenPlSuff-er$

% sie (plural)
$PProNoGendNomPl$ = {<+PPRO><Pers><3><NoGend>}:{<SB>} $PProNomPlSuff$

% sie (plural)
$PProNoGendAccPl$ = {<+PPRO><Pers><3><NoGend>}:{<SB>} $PProAccPlSuff$

% ihr
$PProNoGendDatPl$ = {<+PPRO><Pers><3><NoGend>}:{<SB>} $PProDatPlSuff$

% ihrer, ihr
$PProNoGendGenPl$ = {<+PPRO><Pers><3><NoGend>}:{<SB>} $PProGenPlSuff$

% mich (reflexive)
$PRefl1AccSg$ = {<+PPRO><Refl><1>}:{<SB>} $PProAccSgSuff$

% mir (reflexive)
$PRefl1DatSg$ = {<+PPRO><Refl><1>}:{<SB>} $PProDatSgSuff$

% dich (reflexive)
$PRefl2AccSg$ = {<+PPRO><Refl><2>}:{<SB>} $PProAccSgSuff$

% dir (reflexive)
$PRefl2DatSg$ = {<+PPRO><Refl><2>}:{<SB>} $PProDatSgSuff$

% uns (reflexive)
$PRefl1Pl$ = {<+PPRO><Refl><1>}:{<SB>} $PProAccPlSuff$ | \
             {<+PPRO><Refl><1>}:{<SB>} $PProDatPlSuff$

% euch (reflexive)
$PRefl2Pl$ = {<+PPRO><Refl><2>}:{<SB>} $PProAccPlSuff$ | \
             {<+PPRO><Refl><2>}:{<SB>} $PProDatPlSuff$

% sich
$PRefl3$ = {<+PPRO><Refl><3>}:{<SB>} $PProAccSgSuff$ | \
           {<+PPRO><Refl><3>}:{<SB>} $PProDatSgSuff$ | \
           {<+PPRO><Refl><3>}:{<SB>} $PProAccPlSuff$ | \
           {<+PPRO><Refl><3>}:{<SB>} $PProDatPlSuff$

% einander
$PRecPl$ = {<+PPRO><Rec><1>}:{<SB>} $PProAccPlSuff$ | \
           {<+PPRO><Rec><1>}:{<SB>} $PProDatPlSuff$ | \
           {<+PPRO><Rec><2>}:{<SB>} $PProDatPlSuff$ | \
           {<+PPRO><Rec><2>}:{<SB>} $PProAccPlSuff$ | \
           {<+PPRO><Rec><3>}:{<SB>} $PProAccPlSuff$ | \
           {<+PPRO><Rec><3>}:{<SB>} $PProDatPlSuff$ % cf. Duden-Grammatik (2016: § 366)

% wer (interrogative pronoun)
$WProMascNomSg$ = {<+WPRO><Masc>}:{<SB>} $WProNomSgSuff$

% wen (interrogative pronoun)
$WProMascAccSg$ = {<+WPRO><Masc>}:{<SB>} $WProAccSgSuff$

% wem (interrogative pronoun)
$WProMascDatSg$ = {<+WPRO><Masc>}:{<SB>} $WProDatSgSuff$

% wessen, wes (interrogative pronoun)
$WProMascGenSg$ = {<+WPRO><Masc>}:{<SB>} $WProGenSgSuff$

% was (interrogative pronoun)
$WProNeutNomSg$ = {<+WPRO><Neut>}:{<SB>} $WProNomSgSuff$

% was (interrogative pronoun)
$WProNeutAccSg$ = {<+WPRO><Neut>}:{<SB>} $WProAccSgSuff$

% was (interrogative pronoun)
$WProNeutDatSg$ = {<+WPRO><Neut>}:{<SB>} $WProDatSgSuff$ {<NonSt>}:{} % cf. Duden-Grammatik (2016: § 404)

% wessen, wes (interrogative pronoun)
$WProNeutGenSg$ = {<+WPRO><Neut>}:{<SB>} $WProGenSgSuff$

% wer (indefinite pronoun)
$IProMascNomSg$ = {<+INDEF><Masc>}:{<SB>} $IProNomSgSuff$

% wen (indefinite pronoun)
$IProMascAccSg$ = {<+INDEF><Masc>}:{<SB>} $IProAccSgSuff$

% wem (indefinite pronoun)
$IProMascDatSg$ = {<+INDEF><Masc>}:{<SB>} $IProDatSgSuff$

% wessen (indefinite pronoun)
$IProMascGenSg$ = {<+INDEF><Masc>}:{<SB>} $IProGenSgSuff$

% was (indefinite pronoun)
$IProNeutNomSg$ = {<+INDEF><Neut>}:{<SB>} $IProNomSgSuff$

% was (indefinite pronoun)
$IProNeutAccSg$ = {<+INDEF><Neut>}:{<SB>} $IProAccSgSuff$

% was (indefinite pronoun)
$IProNeutDatSg$ = {<+INDEF><Neut>}:{<SB>} $IProDatSgSuff$ {<NonSt>}:{}

% wessen (indefinite pronoun)
$IProNeutGenSg$ = {<+INDEF><Neut>}:{<SB>} $IProGenSgSuff$


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
$Card-ein$ = {<+CARD>}:{<SB>} $CardSuff-ein$

% kein, keine (cardinal)
$Card-kein$ = {<+CARD>}:{<SB>} $CardSuff-kein$

% zwei, zweien, zweier; drei, dreien, dreier
$Card-zwei$ = {<+CARD>}:{<SB>} $CardSuff-zwei$

% vier, vieren; zwölf, zwölfen
$Card-vier$ = {<+CARD>}:{<SB>} $CardSuff-vier$

% sieben
$Card-sieben$ = {<+CARD>}:{<SB>} $CardSuff-sieben$

% null; zwo; dreizehn; zwanzig; hundert
$Card0$ = <+CARD>:<> $CardSuff0$

% erst-
$Ord$ = {<+ORD>}:{<SB>} $AdjInflSuff$

% eineinhalb; anderthalb; drittel
$Frac0$ = <+FRAC>:<> $CardSuff0$

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
$VAPres13PlInd$ = {<+V><1><Pl><Pres><Ind>}:{} | \
                  {<+V><3><Pl><Pres><Ind>}:{}

% seid; habt; werdet; tut
$VAPres2PlInd$ = {<+V><2><Pl><Pres><Ind>}:{}

% sei; habe; werde; tue
$VAPres13SgSubj$ = {<+V><1><Sg><Pres><Subj>}:{<SB>} | \
                   {<+V><3><Sg><Pres><Subj>}:{<SB>}

% seist, seiest; habest; werdest; tuest
$VAPres2SgSubj$ = {<+V><2><Sg><Pres><Subj>}:{<SB>st}

$VAPresSubjSg$ = {<+V><1><Sg><Pres><Subj>}:{<SB>}   | \
                 {<+V><2><Sg><Pres><Subj>}:{<SB>st} | \
                 {<+V><3><Sg><Pres><Subj>}:{<SB>}

$VAPresSubjPl$ = {<+V><1><Pl><Pres><Subj>}:{<SB>n} | \
                 {<+V><2><Pl><Pres><Subj>}:{<SB>t} | \
                 {<+V><3><Pl><Pres><Subj>}:{<SB>n}

% ward, wardst
$VAPastIndSg$ = {<+V><1><Sg><Past><Ind>}:{<SB>}   | \
                {<+V><2><Sg><Past><Ind>}:{<SB>st} | \
                {<+V><3><Sg><Past><Ind>}:{<SB>}

% wurden, wurdet
$VAPastIndPl$ = {<+V><1><Pl><Past><Ind>}:{<SB>en}   | \
                {<+V><2><Pl><Past><Ind>}:{<INS-E>t} | \
                {<+V><3><Pl><Past><Ind>}:{<SB>en}

$VAPastSubj2$ = {<+V><2><Sg><Past><Subj>}:{<SB>st} | \
                {<+V><2><Pl><Past><Subj>}:{<SB>t}

$haben$ = {<haben>}:{}

$sein$ = {<sein>}:{}

$VPPres$ = {<+V><PPres>}:{} | \
           {<+V><PPres><zu>}:{<^zz>}

$VPPast$ = {<+V><PPast>}:{<^pp>}

$VPPast+haben$ = $VPPast$ $haben$

$VPPast+sein$ = $VPPast$ $sein$

$VPP-en$ = {}:{<SB>en} $VPPast$

$VPP-t$ =  {}:{<INS-E>t} $VPPast$

$VInf$ = {<+V><Inf>}:{} | \
         {<+V><Inf><zu>}:{<^zz>}

$VInf_PPres$ =        $VInf$ | \
               {}:{d} $VPPres$

$VInfStem$ = {}:{<SB>en} $VInf_PPres$

% sein, seiend; tun, tuend
$VInfStem-n$ = {}:{<SB>n}   $VInf$ | \
               {}:{<SB>end} $VPPres$

$VInf-en$ =    $VInfStem$

$VInf-n$ =     $VInfStem-n$

% komm(e); schau(e); arbeit(e); widme
$VImpSg$ = {<+V><Imp><Sg>}:{<INS-E><^imp>} | \
           {<+V><Imp><Sg>}:{<SB>e<^imp>}

% flicht
$VImpSg0$ = {<+V><Imp><Sg>}:{<^imp>}

% kommt; schaut; arbeitet
$VImpPl$ = {<+V><Imp><Pl>}:{<INS-E>t<^imp>}

% will; bedarf
$VPres1Irreg$ = {<+V><1><Sg><Pres><Ind>}:{<SB>}

% liebe; rate; sammle
$VPres1Reg$ = {<+V><1><Sg><Pres><Ind>}:{<SB>e}

% hilfst; rätst
$VPres2Irreg$ = {<+V><2><Sg><Pres><Ind>}:{<SB>st}

% liebst; bietest; sammelst
$VPres2Reg$ = {<+V><2><Sg><Pres><Ind>}:{<INS-E>st}

% rät; will
$VPres3Irreg$ = {<+V><3><Sg><Pres><Ind>}:{<SB>}

% liebt; hilft; sammelt
$VPres3Reg$ = {<+V><3><Sg><Pres><Ind>}:{<INS-E>t}

% lieben; wollen; sammeln
% liebt; bietet; sammelt
$VPresPlInd$ = {<+V><1><Pl><Pres><Ind>}:{<SB>en}   | \
               {<+V><2><Pl><Pres><Ind>}:{<INS-E>t} | \
               {<+V><3><Pl><Pres><Ind>}:{<SB>en}

% liebe; wolle; sammle
% liebest; wollest; sammelst
% lieben; wollen; sammeln
% liebet; wollet; sammelt
$VPresSubj$ = {<+V><1><Sg><Pres><Subj>}:{<SB>e}   | \
              {<+V><2><Sg><Pres><Subj>}:{<SB>est} | \
              {<+V><3><Sg><Pres><Subj>}:{<SB>e}   | \
              {<+V><1><Pl><Pres><Subj>}:{<SB>en}  | \
              {<+V><2><Pl><Pres><Subj>}:{<SB>et}  | \
              {<+V><3><Pl><Pres><Subj>}:{<SB>en}

% brachte
$VPastIndReg$ = {<+V><1><Sg><Past><Ind>}:{<INS-E>te}   | \
                {<+V><2><Sg><Past><Ind>}:{<INS-E>test} | \
                {<+V><3><Sg><Past><Ind>}:{<INS-E>te}   | \
                {<+V><1><Pl><Past><Ind>}:{<INS-E>ten}  | \
                {<+V><2><Pl><Past><Ind>}:{<INS-E>tet}  | \
                {<+V><3><Pl><Past><Ind>}:{<INS-E>ten}

% wurde
$VPastIndIrreg$ = {<+V><1><Sg><Past><Ind>}:{<SB>e}   | \
                  {<+V><2><Sg><Past><Ind>}:{<SB>est} | \
                  {<+V><3><Sg><Past><Ind>}:{<SB>e}   | \
                  {<+V><1><Pl><Past><Ind>}:{<SB>en}  | \
                  {<+V><2><Pl><Past><Ind>}:{<SB>et}  | \
                  {<+V><3><Pl><Past><Ind>}:{<SB>en}

% fuhr; ritt; fand
% fuhrst; rittest; fandest
$VPastIndStr$ = {<+V><1><Sg><Past><Ind>}:{<SB>}      | \
                {<+V><2><Sg><Past><Ind>}:{<INS-E>st} | \
                {<+V><3><Sg><Past><Ind>}:{<SB>}      | \
                {<+V><1><Pl><Past><Ind>}:{<SB>en}    | \
                {<+V><2><Pl><Past><Ind>}:{<INS-E>t}  | \
                {<+V><3><Pl><Past><Ind>}:{<SB>en}

% brächte
$VPastSubjReg$ = {<+V><1><Sg><Past><Subj>}:{<INS-E>te}   | \
                 {<+V><2><Sg><Past><Subj>}:{<INS-E>test} | \
                 {<+V><3><Sg><Past><Subj>}:{<INS-E>te}   | \
                 {<+V><1><Pl><Past><Subj>}:{<INS-E>ten}  | \
                 {<+V><2><Pl><Past><Subj>}:{<INS-E>tet}  | \
                 {<+V><3><Pl><Past><Subj>}:{<INS-E>ten}

% führe; ritte; fände
$VPastSubjStr$ = {<+V><1><Sg><Past><Subj>}:{<SB>e}   | \
                 {<+V><2><Sg><Past><Subj>}:{<SB>est} | \
                 {<+V><3><Sg><Past><Subj>}:{<SB>e}   | \
                 {<+V><1><Pl><Past><Subj>}:{<SB>en}  | \
                 {<+V><2><Pl><Past><Subj>}:{<SB>et}  | \
                 {<+V><3><Pl><Past><Subj>}:{<SB>en}

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

$VVPres1_Imp$ = $VImpSg$ | \
                $VVPres1$

$VVPres2$ = $VInflPres2$

$VVPres2t$ = $VInflPres2t$

$VVPres2_Imp$ = $VImpSg$ | \
                $VVPres2$

$VVPres2_Imp0$ = $VImpSg0$ | \
                 $VVPres2$

$VVPres2t_Imp0$ = $VImpSg0$ | \
                  $VVPres2t$

% bedarf-; weiss-
$VVPresSg$ = $VModInflSg$

% bedürf-; wiss-
$VVPresPl$ = $VModInflPl$ | \
             $VInfStem$

$VVPastIndReg$ = $VPastIndReg$

$VVPastIndStr$ = $VPastIndStr$

$VVPastSubjReg$ = $VPastSubjReg$

$VVPastSubjStr$ = $VPastSubjStr$

$VVPastSubjOld$ = $VVPastSubjStr$ {<Old>}:{}

$VVPastStr$ = $VVPastIndStr$ | \
              $VVPastSubjStr$

$VVRegFin$ = $VInflReg$

% lieben; spielen
$VVReg$ = $VInflReg$ | \
          $VPP-t$    | \
          $VInfStem$

$VVReg+haben$ = $VInflReg$ | \
                $VPP-t$ $haben$ | \
                $VInfStem$

$VVReg+sein$ = $VInflReg$ | \
               $VPP-t$ $sein$ | \
               $VInfStem$

% angeln; rudern (cf. $SchwaTrigger$ in markers.fst)
$VVReg-el-er$ = $VVReg$

$VVReg-el-er+haben$ = $VVReg+haben$

$VVReg-el-er+sein$ = $VVReg+sein$

$VMPastSubj$ = $VPastSubjReg$

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

% unter
$Prep$ = {<+PREP>}:{}

% unterm
$Prep+Art-m$ = {<+PREPART><Masc><Dat><Sg>}:{} | \
               {<+PREPART><Neut><Dat><Sg>}:{}

% untern
$Prep+Art-n$ = {<+PREPART><Masc><Acc><Sg>}:{}

% unters
$Prep+Art-s$ = {<+PREPART><Neut><Acc><Sg>}:{}

% zur
$Prep+Art-r$ = {<+PREPART><Fem><Dat><Sg>}:{}

% zufolge, willen
$Postp$ = {<+POSTP>}:{}


% other words

$Intj$ = {<+INTJ>}:{}

$ConjInf$ = {<+CONJ><Inf>}:{}

$ConjCoord$ = {<+CONJ><Coord>}:{}

$ConjSub$ = {<+CONJ><Sub>}:{}

$ConjCompar$ = {<+CONJ><Compar>}:{}

$PIndInvar$ = {<+INDEF><Invar>}:{}

$ProAdv$ = {<+PROADV>}:{}

$PtclAdj$ = {<+PTCL><Adj>}:{}

$PtclNeg$ = {<+PTCL><Neg>}:{}

$Ptcl-zu$ = {<+PTCL><zu>}:{}

$WAdv$ = {<+WADV>}:{}

$VPart$ = {<+VPART>}:{}


% abbreviations

% Kfm. (= Kaufmann)
$AbbrNMasc$ = {<+NN><Masc><Invar>}:{}

% Gr. (= Gros)
$AbbrNNeut$ = {<+NN><Neut><Invar>}:{}

% Kffr. (= Kauffrau)
$AbbrNFem$ = {<+NN><Fem><Invar>}:{}

% Gebr. (= Gebrüder)
$AbbrNNoGend$ = {<+NN><NoGend><Invar>}:{}

% f. (= folgende)
$AbbrAdj$ = {<+ADJ><Pos><Invar>}:{}

% Ew. (= Euer)
$AbbrPoss$ = {<+POSS><Attr><Invar>}:{}

% vgl. (= vergleiche)
$AbbrVImp$ = {<+V><Imp><Invar>}:{}


% inflection transducer

$INFL$ = <>:<AbbrAdj>               $AbbrAdj$              | \
         <>:<AbbrNFem>              $AbbrNFem$             | \
         <>:<AbbrNMasc>             $AbbrNMasc$            | \
         <>:<AbbrNNeut>             $AbbrNNeut$            | \
         <>:<AbbrNNoGend>           $AbbrNNoGend$          | \
         <>:<AbbrPoss>              $AbbrPoss$             | \
         <>:<AbbrVImp>              $AbbrVImp$             | \
         <>:<Adj-el_$>              $Adj-el_\$$            | \
         <>:<Adj-el_0>              $Adj-el_0$             | \
         <>:<Adj-en_0>              $Adj-en_0$             | \
         <>:<Adj-er_0>              $Adj-er_0$             | \
         <>:<Adj-Lang>              $Adj-Lang$             | \
         <>:<Adj_$>                 $Adj_\$$               | \
         <>:<Adj_$e>                $Adj_\$e$              | \
         <>:<Adj_0>                 $Adj_0$                | \
         <>:<Adj_e>                 $Adj_e$                | \
         <>:<AdjComp>               $AdjComp$              | \
         <>:<AdjComp0-mehr>         $AdjComp0-mehr$        | \
         <>:<AdjPos>                $AdjPos$               | \
         <>:<AdjPos0>               $AdjPos0$              | \
         <>:<AdjPos0-viel>          $AdjPos0-viel$         | \
         <>:<AdjPos0Attr>           $AdjPos0Attr$          | \
         <>:<AdjPos0AttrSubst>      $AdjPos0AttrSubst$     | \
         <>:<AdjPosAttr>            $AdjPosAttr$           | \
         <>:<AdjPosAttr-er>         $AdjPosAttr-er$        | \
         <>:<AdjPosPred>            $AdjPosPred$           | \
         <>:<AdjSup>                $AdjSup$               | \
         <>:<AdjSup-aller>          $AdjSup-aller$         | \
         <>:<AdjSupAttr>            $AdjSupAttr$           | \
         <>:<Adv>                   $Adv$                  | \
         <>:<AdvComp>               $AdvComp$              | \
         <>:<AdvComp0>              $AdvComp0$             | \
         <>:<AdvSup>                $AdvSup$               | \
         <>:<ArtDef>                $ArtDef$               | \
         <>:<ArtDef-das+DemNeut>    $ArtDef-das+DemNeut$   | \
         <>:<ArtDef-dem+DemMasc>    $ArtDef-dem+DemMasc$   | \
         <>:<ArtDef-dem+DemNeut>    $ArtDef-dem+DemNeut$   | \
         <>:<ArtDef-den+DemMasc>    $ArtDef-den+DemMasc$   | \
         <>:<ArtDef-den+DemNoGend>  $ArtDef-den+DemNoGend$ | \
         <>:<ArtDef-der+DemFem>     $ArtDef-der+DemFem$    | \
         <>:<ArtDef-der+DemMasc>    $ArtDef-der+DemMasc$   | \
         <>:<ArtDef-der+DemNoGend>  $ArtDef-der+DemNoGend$ | \
         <>:<ArtDef-des+DemMasc>    $ArtDef-des+DemMasc$   | \
         <>:<ArtDef-des+DemNeut>    $ArtDef-des+DemNeut$   | \
         <>:<ArtDef-die+DemFem>     $ArtDef-die+DemFem$    | \
         <>:<ArtDef-die+DemNoGend>  $ArtDef-die+DemNoGend$ | \
         <>:<ArtIndef>              $ArtIndef$             | \
         <>:<ArtIndef-n>            $ArtIndef-n$           | \
         <>:<ArtNeg>                $ArtNeg$               | \
         <>:<Card0>                 $Card0$                | \
         <>:<Card-ein>              $Card-ein$             | \
         <>:<Card-kein>             $Card-kein$            | \
         <>:<Card-sieben>           $Card-sieben$          | \
         <>:<Card-vier>             $Card-vier$            | \
         <>:<Card-zwei>             $Card-zwei$            | \
         <>:<ConjCompar>            $ConjCompar$           | \
         <>:<ConjCoord>             $ConjCoord$            | \
         <>:<ConjInf>               $ConjInf$              | \
         <>:<ConjSub>               $ConjSub$              | \
         <>:<Dem>                   $Dem$                  | \
         <>:<Dem0>                  $Dem0$                 | \
         <>:<Dem-alldem>            $Dem-alldem$           | \
         <>:<Dem-dies>              $Dem-dies$             | \
         <>:<Dem-solch>             $Dem-solch$            | \
         <>:<DemDef>                $DemDef$               | \
         <>:<DigCard>               $DigCard$              | \
         <>:<DigFrac>               $DigFrac$              | \
         <>:<DigOrd>                $DigOrd$               | \
         <>:<Frac0>                 $Frac0$                | \
         <>:<Indef0>                $Indef0$               | \
         <>:<Indef-all>             $Indef-all$            | \
         <>:<Indef-beid>            $Indef-beid$           | \
         <>:<Indef-ein>             $Indef-ein$            | \
         <>:<Indef-einig>           $Indef-einig$          | \
         <>:<Indef-irgendein>       $Indef-irgendein$      | \
         <>:<Indef-irgendwelch>     $Indef-irgendwelch$    | \
         <>:<Indef-jed>             $Indef-jed$            | \
         <>:<Indef-jeglich>         $Indef-jeglich$        | \
         <>:<Indef-kein>            $Indef-kein$           | \
         <>:<Indef-manch>           $Indef-manch$          | \
         <>:<Indef-mehrer>          $Indef-mehrer$         | \
         <>:<Indef-saemtlich>       $Indef-saemtlich$      | \
         <>:<Indef-welch>           $Indef-welch$          | \
         <>:<IPro-jedermann>        $IPro-jedermann$       | \
         <>:<IPro-man>              $IPro-man$             | \
         <>:<IPro-unsereiner>       $IPro-unsereiner$      | \
         <>:<IPro-unsereins>        $IPro-unsereins$       | \
         <>:<IProMasc>              $IProMasc$             | \
         <>:<IProMascAccSg>         $IProMascAccSg$        | \
         <>:<IProMascDatSg>         $IProMascDatSg$        | \
         <>:<IProMascGenSg>         $IProMascGenSg$        | \
         <>:<IProMascNomSg>         $IProMascNomSg$        | \
         <>:<IProNeut>              $IProNeut$             | \
         <>:<IProNeutAccSg>         $IProNeutAccSg$        | \
         <>:<IProNeutDatSg>         $IProNeutDatSg$        | \
         <>:<IProNeutGenSg>         $IProNeutGenSg$        | \
         <>:<IProNeutNomSg>         $IProNeutNomSg$        | \
         <>:<Intj>                  $Intj$                 | \
         <>:<Name-Fam_0>            $Name-Fam_0$           | \
         <>:<Name-Fam_s>            $Name-Fam_s$           | \
         <>:<NameFem_0>             $NameFem_0$            | \
         <>:<NameFem_apos>          $NameFem_apos$         | \
         <>:<NameFem_s>             $NameFem_s$            | \
         <>:<NameMasc_0>            $NameMasc_0$           | \
         <>:<NameMasc_apos>         $NameMasc_apos$        | \
         <>:<NameMasc_es>           $NameMasc_es$          | \
         <>:<NameMasc_s>            $NameMasc_s$           | \
         <>:<NameNeut_0>            $NameNeut_0$           | \
         <>:<NameNeut_apos>         $NameNeut_apos$        | \
         <>:<NameNeut_es>           $NameNeut_es$          | \
         <>:<NameNeut_s>            $NameNeut_s$           | \
         <>:<NameNoGend/Pl_0>       $NameNoGend/Pl_0$      | \
         <>:<NameNoGend/Pl_x>       $NameNoGend/Pl_x$      | \
         <>:<NFem-Adj>              $NFem-Adj$             | \
         <>:<NFem-in>               $NFem-in$              | \
         <>:<NFem/Sg_0>             $NFem/Sg_0$            | \
         <>:<NFem_0_$>              $NFem_0_\$$            | \
         <>:<NFem_0_$e>             $NFem_0_\$e$           | \
         <>:<NFem_0_$en>            $NFem_0_\$en$          | \
         <>:<NFem_0_0>              $NFem_0_0$             | \
         <>:<NFem_0_a/en>           $NFem_0_a/en$          | \
         <>:<NFem_0_e>              $NFem_0_e$             | \
         <>:<NFem_0_e~ss>           $NFem_0_e~ss$          | \
         <>:<NFem_0_anx/angen>      $NFem_0_anx/angen$     | \
         <>:<NFem_0_e/i>            $NFem_0_e/i$           | \
         <>:<NFem_0_en>             $NFem_0_en$            | \
         <>:<NFem_0_es>             $NFem_0_es$            | \
         <>:<NFem_0_ex/eges>        $NFem_0_ex/eges$       | \
         <>:<NFem_0_is/en>          $NFem_0_is/en$         | \
         <>:<NFem_0_is/iden>        $NFem_0_is/iden$       | \
         <>:<NFem_0_ix/izen>        $NFem_0_ix/izen$       | \
         <>:<NFem_0_ix/izes>        $NFem_0_ix/izes$       | \
         <>:<NFem_0_n>              $NFem_0_n$             | \
         <>:<NFem_0_s>              $NFem_0_s$             | \
         <>:<NFem_0_x>              $NFem_0_x$             | \
         <>:<NMasc-Adj>             $NMasc-Adj$            | \
         <>:<NMasc/Sg_0>            $NMasc/Sg_0$           | \
         <>:<NMasc/Sg_es>           $NMasc/Sg_es$          | \
         <>:<NMasc/Sg_ns>           $NMasc/Sg_ns$          | \
         <>:<NMasc/Sg_s>            $NMasc/Sg_s$           | \
         <>:<NMasc_0_$e>            $NMasc_0_\$e$          | \
         <>:<NMasc_0_0>             $NMasc_0_0$            | \
         <>:<NMasc_0_as/anten>      $NMasc_0_as/anten$     | \
         <>:<NMasc_0_e>             $NMasc_0_e$            | \
         <>:<NMasc_0_e~ss>          $NMasc_0_e~ss$         | \
         <>:<NMasc_0_e/i>           $NMasc_0_e/i$          | \
         <>:<NMasc_0_en>            $NMasc_0_en$           | \
         <>:<NMasc_0_es>            $NMasc_0_es$           | \
         <>:<NMasc_0_ex/izes>       $NMasc_0_ex/izes$      | \
         <>:<NMasc_0_nen>           $NMasc_0_nen$          | \
         <>:<NMasc_0_o/en>          $NMasc_0_o/en$         | \
         <>:<NMasc_0_o/i>           $NMasc_0_o/i$          | \
         <>:<NMasc_0_s>             $NMasc_0_s$            | \
         <>:<NMasc_0_us/e>          $NMasc_0_us/e$         | \
         <>:<NMasc_0_us/een>        $NMasc_0_us/een$       | \
         <>:<NMasc_0_us/en>         $NMasc_0_us/en$        | \
         <>:<NMasc_0_us/i>          $NMasc_0_us/i$         | \
         <>:<NMasc_0_us/ier>        $NMasc_0_us/ier$       | \
         <>:<NMasc_0_ynx/yngen>     $NMasc_0_ynx/yngen$    | \
         <>:<NMasc_0_x>             $NMasc_0_x$            | \
         <>:<NMasc_en_en>           $NMasc_en_en$          | \
         <>:<NMasc_es_$e>           $NMasc_es_\$e$         | \
         <>:<NMasc_es_$er>          $NMasc_es_\$er$        | \
         <>:<NMasc_es_as/anten~ss>  $NMasc_es_as/anten~ss$ | \
         <>:<NMasc_es_e>            $NMasc_es_e$           | \
         <>:<NMasc_es_e~ss>         $NMasc_es_e~ss$        | \
         <>:<NMasc_es_en>           $NMasc_es_en$          | \
         <>:<NMasc_es_er>           $NMasc_es_er$          | \
         <>:<NMasc_es_es>           $NMasc_es_es$          | \
         <>:<NMasc_es_s>            $NMasc_es_s$           | \
         <>:<NMasc_es_ten>          $NMasc_es_ten$         | \
         <>:<NMasc_es_ex/izes>      $NMasc_es_ex/izes$     | \
         <>:<NMasc_es_us/een~ss>    $NMasc_es_us/een~ss$   | \
         <>:<NMasc_es_us/en~ss>     $NMasc_es_us/en~ss$    | \
         <>:<NMasc_es_us/i~ss>      $NMasc_es_us/i~ss$     | \
         <>:<NMasc_n_n>             $NMasc_n_n$            | \
         <>:<NMasc_ns_n>            $NMasc_ns_n$           | \
         <>:<NMasc_ns_$n>           $NMasc_ns_\$n$         | \
         <>:<NMasc_s_$>             $NMasc_s_\$$           | \
         <>:<NMasc_s_$e>            $NMasc_s_\$e$          | \
         <>:<NMasc_s_$er>           $NMasc_s_\$er$         | \
         <>:<NMasc_s_$x>            $NMasc_s_\$x$          | \
         <>:<NMasc_s_0>             $NMasc_s_0$            | \
         <>:<NMasc_s_e>             $NMasc_s_e$            | \
         <>:<NMasc_s_e/i>           $NMasc_s_e/i$          | \
         <>:<NMasc_s_en>            $NMasc_s_en$           | \
         <>:<NMasc_s_er>            $NMasc_s_er$           | \
         <>:<NMasc_s_es>            $NMasc_s_es$          | \
         <>:<NMasc_s_n>             $NMasc_s_n$            | \
         <>:<NMasc_s_nen>           $NMasc_s_nen$          | \
         <>:<NMasc_s_o/en>          $NMasc_s_o/en$         | \
         <>:<NMasc_s_o/i>           $NMasc_s_o/i$          | \
         <>:<NMasc_s_s>             $NMasc_s_s$            | \
         <>:<NMasc_s_x>             $NMasc_s_x$            | \
         <>:<NNeut-Adj>             $NNeut-Adj$            | \
         <>:<NNeut-Adj/Sg>          $NNeut-Adj/Sg$         | \
         <>:<NNeut-Inner>           $NNeut-Inner$          | \
         <>:<NNeut/Pl_0>            $NNeut/Pl_0$           | \
         <>:<NNeut/Sg_0>            $NNeut/Sg_0$           | \
         <>:<NNeut/Sg_es>           $NNeut/Sg_es$          | \
         <>:<NNeut/Sg_es~ss>        $NNeut/Sg_es~ss$       | \
         <>:<NNeut/Sg_s>            $NNeut/Sg_s$           | \
         <>:<NNeut_0_0>             $NNeut_0_0$            | \
         <>:<NNeut_0_a/ata>         $NNeut_0_a/ata$        | \
         <>:<NNeut_0_a/en>          $NNeut_0_a/en$         | \
         <>:<NNeut_0_ans/anzien>    $NNeut_0_ans/anzien$   | \
         <>:<NNeut_0_e>             $NNeut_0_e$            | \
         <>:<NNeut_0_e~ss>          $NNeut_0_e~ss$         | \
         <>:<NNeut_0_e/i>           $NNeut_0_e/i$          | \
         <>:<NNeut_0_en>            $NNeut_0_en$           | \
         <>:<NNeut_0_en/ina>        $NNeut_0_en/ina$       | \
         <>:<NNeut_0_ens/enzien>    $NNeut_0_ens/enzien$   | \
         <>:<NNeut_0_es>            $NNeut_0_es$           | \
         <>:<NNeut_0_nen>           $NNeut_0_nen$          | \
         <>:<NNeut_0_o/en>          $NNeut_0_o/en$         | \
         <>:<NNeut_0_o/i>           $NNeut_0_o/i$          | \
         <>:<NNeut_0_on/a>          $NNeut_0_on/a$         | \
         <>:<NNeut_0_on/en>         $NNeut_0_on/en$        | \
         <>:<NNeut_0_s>             $NNeut_0_s$            | \
         <>:<NNeut_0_um/a>          $NNeut_0_um/a$         | \
         <>:<NNeut_0_um/en>         $NNeut_0_um/en$        | \
         <>:<NNeut_0_us/en>         $NNeut_0_us/en$        | \
         <>:<NNeut_0_us/era>        $NNeut_0_us/era$       | \
         <>:<NNeut_0_us/ora>        $NNeut_0_us/ora$       | \
         <>:<NNeut_0_x>             $NNeut_0_x$            | \
         <>:<NNeut_ens_en>          $NNeut_ens_en$         | \
         <>:<NNeut_es_$e>           $NNeut_es_\$e$         | \
         <>:<NNeut_es_$er>          $NNeut_es_\$er$        | \
         <>:<NNeut_es_e>            $NNeut_es_e$           | \
         <>:<NNeut_es_e~ss>         $NNeut_es_e~ss$        | \
         <>:<NNeut_es_en>           $NNeut_es_en$          | \
         <>:<NNeut_es_er>           $NNeut_es_er$          | \
         <>:<NNeut_es_es>           $NNeut_es_es$          | \
         <>:<NNeut_es_ien>          $NNeut_es_ien$         | \
         <>:<NNeut_es_s>            $NNeut_es_s$           | \
         <>:<NNeut_s_$>             $NNeut_s_\$$           | \
         <>:<NNeut_s_$er>           $NNeut_s_\$er$         | \
         <>:<NNeut_s_0>             $NNeut_s_0$            | \
         <>:<NNeut_s_a/ata>         $NNeut_s_a/ata$        | \
         <>:<NNeut_s_a/en>          $NNeut_s_a/en$         | \
         <>:<NNeut_s_e>             $NNeut_s_e$            | \
         <>:<NNeut_s_e/i>           $NNeut_s_e/i$          | \
         <>:<NNeut_s_en>            $NNeut_s_en$           | \
         <>:<NNeut_s_en/ina>        $NNeut_s_en/ina$       | \
         <>:<NNeut_s_ien>           $NNeut_s_ien$          | \
         <>:<NNeut_s_n>             $NNeut_s_n$            | \
         <>:<NNeut_s_nen>           $NNeut_s_nen$          | \
         <>:<NNeut_s_o/en>          $NNeut_s_o/en$         | \
         <>:<NNeut_s_o/i>           $NNeut_s_o/i$          | \
         <>:<NNeut_s_on/a>          $NNeut_s_on/a$         | \
         <>:<NNeut_s_on/en>         $NNeut_s_on/en$        | \
         <>:<NNeut_s_s>             $NNeut_s_s$            | \
         <>:<NNeut_s_um/a>          $NNeut_s_um/a$         | \
         <>:<NNeut_s_um/en>         $NNeut_s_um/en$        | \
         <>:<NNeut_s_x>             $NNeut_s_x$            | \
         <>:<NNoGend/Pl_0>          $NNoGend/Pl_0$         | \
         <>:<NNoGend/Pl_x>          $NNoGend/Pl_x$         | \
         <>:<Ord>                   $Ord$                  | \
         <>:<PIndInvar>             $PIndInvar$            | \
         <>:<Poss>                  $Poss$                 | \
         <>:<Poss-er>               $Poss-er$              | \
         <>:<Poss/Wk>               $Poss/Wk$              | \
         <>:<Poss/Wk-er>            $Poss/Wk-er$           | \
         <>:<Postp>                 $Postp$                | \
         <>:<PPro1AccPl>            $PPro1AccPl$           | \
         <>:<PPro1AccSg>            $PPro1AccSg$           | \
         <>:<PPro1DatPl>            $PPro1DatPl$           | \
         <>:<PPro1DatSg>            $PPro1DatSg$           | \
         <>:<PPro1GenPl>            $PPro1GenPl$           | \
         <>:<PPro1GenSg>            $PPro1GenSg$           | \
         <>:<PPro1NomPl>            $PPro1NomPl$           | \
         <>:<PPro1NomSg>            $PPro1NomSg$           | \
         <>:<PPro2AccPl>            $PPro2AccPl$           | \
         <>:<PPro2AccSg>            $PPro2AccSg$           | \
         <>:<PPro2DatPl>            $PPro2DatPl$           | \
         <>:<PPro2DatSg>            $PPro2DatSg$           | \
         <>:<PPro2GenPl>            $PPro2GenPl$           | \
         <>:<PPro2GenSg>            $PPro2GenSg$           | \
         <>:<PPro2NomPl>            $PPro2NomPl$           | \
         <>:<PPro2NomSg>            $PPro2NomSg$           | \
         <>:<PProFemAccSg>          $PProFemAccSg$         | \
         <>:<PProFemDatSg>          $PProFemDatSg$         | \
         <>:<PProFemGenSg>          $PProFemGenSg$         | \
         <>:<PProFemNomSg>          $PProFemNomSg$         | \
         <>:<PProMascAccSg>         $PProMascAccSg$        | \
         <>:<PProMascDatSg>         $PProMascDatSg$        | \
         <>:<PProMascGenSg>         $PProMascGenSg$        | \
         <>:<PProMascNomSg>         $PProMascNomSg$        | \
         <>:<PProNeutAccSg>         $PProNeutAccSg$        | \
         <>:<PProNeutAccSg-s>       $PProNeutAccSg-s$      | \
         <>:<PProNeutDatSg>         $PProNeutDatSg$        | \
         <>:<PProNeutGenSg>         $PProNeutGenSg$        | \
         <>:<PProNeutNomSg>         $PProNeutNomSg$        | \
         <>:<PProNeutNomSg-s>       $PProNeutNomSg-s$      | \
         <>:<PProNoGendAccPl>       $PProNoGendAccPl$      | \
         <>:<PProNoGendDatPl>       $PProNoGendDatPl$      | \
         <>:<PProNoGendGenPl>       $PProNoGendGenPl$      | \
         <>:<PProNoGendNomPl>       $PProNoGendNomPl$      | \
         <>:<PRecPl>                $PRecPl$               | \
         <>:<PRefl1AccSg>           $PRefl1AccSg$          | \
         <>:<PRefl1DatSg>           $PRefl1DatSg$          | \
         <>:<PRefl2AccSg>           $PRefl2AccSg$          | \
         <>:<PRefl2DatSg>           $PRefl2DatSg$          | \
         <>:<PRefl1Pl>              $PRefl1Pl$             | \
         <>:<PRefl2Pl>              $PRefl2Pl$             | \
         <>:<PRefl3>                $PRefl3$               | \
         <>:<Prep>                  $Prep$                 | \
         <>:<Prep+Art-m>            $Prep+Art-m$           | \
         <>:<Prep+Art-n>            $Prep+Art-n$           | \
         <>:<Prep+Art-r>            $Prep+Art-r$           | \
         <>:<Prep+Art-s>            $Prep+Art-s$           | \
         <>:<ProAdv>                $ProAdv$               | \
         <>:<PtclAdj>               $PtclAdj$              | \
         <>:<PtclNeg>               $PtclNeg$              | \
         <>:<Ptcl-zu>               $Ptcl-zu$              | \
         <>:<Rel>                   $Rel$                  | \
         <>:<Rel-welch>             $Rel-welch$            | \
         <>:<Roman>                 $Roman$                | \
         <>:<VAImpPl>               $VAImpPl$              | \
         <>:<VAImpSg>               $VAImpSg$              | \
         <>:<VAPastIndPl>           $VAPastIndPl$          | \
         <>:<VAPastIndSg>           $VAPastIndSg$          | \
         <>:<VAPastSubj2>           $VAPastSubj2$          | \
         <>:<VAPres13PlInd>         $VAPres13PlInd$        | \
         <>:<VAPres13SgSubj>        $VAPres13SgSubj$       | \
         <>:<VAPres1SgInd>          $VAPres1SgInd$         | \
         <>:<VAPres2PlInd>          $VAPres2PlInd$         | \
         <>:<VAPres2SgInd>          $VAPres2SgInd$         | \
         <>:<VAPres2SgSubj>         $VAPres2SgSubj$        | \
         <>:<VAPres3SgInd>          $VAPres3SgInd$         | \
         <>:<VAPresSubjPl>          $VAPresSubjPl$         | \
         <>:<VAPresSubjSg>          $VAPresSubjSg$         | \
         <>:<VInf_PPres>            $VInf_PPres$           | \
         <>:<VInf-en>               $VInf-en$              | \
         <>:<VInf-n>                $VInf-n$               | \
         <>:<VInf>                  $VInf$                 | \
         <>:<VMPast>                $VMPast$               | \
         <>:<VMPast><>:<haben>      $VMPast+haben$         | \
         <>:<VMPast><>:<sein>       $VMPast+sein$          | \
         <>:<VMPastSubj>            $VMPastSubj$           | \
         <>:<VMPresPl>              $VMPresPl$             | \
         <>:<VMPresSg>              $VMPresSg$             | \
         <>:<VPart>                 $VPart$                | \
         <>:<VPPast>                $VPPast$               | \
         <>:<VPPast><>:<haben>      $VPPast+haben$         | \
         <>:<VPPast><>:<sein>       $VPPast+sein$          | \
         <>:<VPastIndIrreg>         $VPastIndIrreg$        | \
         <>:<VPastIndReg>           $VPastIndReg$          | \
         <>:<VPastIndStr>           $VPastIndStr$          | \
         <>:<VPastSubjStr>          $VPastSubjStr$         | \
         <>:<VPPres>                $VPPres$               | \
         <>:<VPresPlInd>            $VPresPlInd$           | \
         <>:<VPresSubj>             $VPresSubj$            | \
         <>:<VVPastIndReg>          $VVPastIndReg$         | \
         <>:<VVPastIndStr>          $VVPastIndStr$         | \
         <>:<VVPastStr>             $VVPastStr$            | \
         <>:<VVPastSubjOld>         $VVPastSubjOld$        | \
         <>:<VVPastSubjReg>         $VVPastSubjReg$        | \
         <>:<VVPastSubjStr>         $VVPastSubjStr$        | \
         <>:<VVPP-en>               $VVPP-en$              | \
         <>:<VVPP-en><>:<haben>     $VVPP-en+haben$        | \
         <>:<VVPP-en><>:<sein>      $VVPP-en+sein$         | \
         <>:<VVPP-t>                $VVPP-t$               | \
         <>:<VVPP-t><>:<haben>      $VVPP-t+haben$         | \
         <>:<VVPP-t><>:<sein>       $VVPP-t+sein$          | \
         <>:<VVPres>                $VVPres$               | \
         <>:<VVPres1>               $VVPres1$              | \
         <>:<VVPres1_Imp>           $VVPres1_Imp$          | \
         <>:<VVPres2>               $VVPres2$              | \
         <>:<VVPres2_Imp>           $VVPres2_Imp$          | \
         <>:<VVPres2_Imp0>          $VVPres2_Imp0$         | \
         <>:<VVPres2t>              $VVPres2t$             | \
         <>:<VVPres2t_Imp0>         $VVPres2t_Imp0$        | \
         <>:<VVPresPl>              $VVPresPl$             | \
         <>:<VVPresSg>              $VVPresSg$             | \
         <>:<VVReg>                 $VVReg$                | \
         <>:<VVReg><>:<haben>       $VVReg+haben$          | \
         <>:<VVReg><>:<sein>        $VVReg+sein$           | \
         <>:<VVReg-el-er>           $VVReg-el-er$          | \
         <>:<VVReg-el-er><>:<haben> $VVReg-el-er+haben$    | \
         <>:<VVReg-el-er><>:<sein>  $VVReg-el-er+sein$     | \
         <>:<VVRegFin>              $VVRegFin$             | \
         <>:<WAdv>                  $WAdv$                 | \
         <>:<W-welch>               $W-welch$              | \
         <>:<WProMascAccSg>         $WProMascAccSg$        | \
         <>:<WProMascDatSg>         $WProMascDatSg$        | \
         <>:<WProMascGenSg>         $WProMascGenSg$        | \
         <>:<WProMascNomSg>         $WProMascNomSg$        | \
         <>:<WProNeutAccSg>         $WProNeutAccSg$        | \
         <>:<WProNeutDatSg>         $WProNeutDatSg$        | \
         <>:<WProNeutGenSg>         $WProNeutGenSg$        | \
         <>:<WProNeutNomSg>         $WProNeutNomSg$


% inflection filter

ALPHABET = [#char# #surface-trigger# #orth-trigger# #ss-trigger# #boundary-trigger# \
            <INS-E><Ge-Nom><UL><ge><zu> \
            <^Ax><^Px><^imp><^zz><^pp><^pl><^Gen><^Del>]

$=INFL$ = [#inflection#]:<>

$=AUX$ = [#auxiliary#]:<>

$InflFilter$ = (.* $=INFL$ $=AUX$ $=INFL$ $=AUX$ .*) | \
               (.* $=INFL$ $=INFL$ .*)
