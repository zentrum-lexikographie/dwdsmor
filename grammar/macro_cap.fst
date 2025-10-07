% macro_cap.fst
% Version 1.0
% Andreas Nolda 2025-10-07

% capitalisation

$Words$ = $Words$ | <CAP>:<> ($Words$ || $OrthCap$)

% In order to enable capitalisation as well as all-caps spelling,
% replace the above re-definition of $Words$ with the following ones.

% $Words$ = $Words$ | (<CAP>:<>  ($Words$ || $OrthCap$)) | \
%                     (<CAPS>:<> ($Words$ || $OrthCaps$))
%
% $Words$ = $Words$ | ($Words$ || $OrthSZ2SS$)
