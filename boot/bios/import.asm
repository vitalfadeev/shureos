;
; import
;

macro import name
{
    if used name
        include `name # '.inc'
    end if
}
