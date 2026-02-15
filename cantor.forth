81 constant WIDTH
4  constant DEPTH

create line WIDTH allot

: fill-line
    WIDTH 0 do
        [char] * line i + c!
    loop ;

: print-line
    WIDTH 0 do
        line i + c@ emit
    loop cr ;

: remove-middle ( start len -- )
    3 / dup >r              \ len/3
    + r@ + swap             \ compute middle start
    r> 0 do
        space over i + c!
    loop drop ;

: step ( size -- )
    WIDTH swap 0 do
        i over remove-middle
    over 3 / +loop
    drop ;

: cantor
    fill-line
    print-line
    WIDTH
    DEPTH 0 do
        dup step
        print-line
        3 /
    loop
    drop ;


>>>><<< cantor.forth
Backtrace:
$102624F30 key-file 
$102646C58 (key) 
$10262E300 xkey 
$10262E3B8 edit-line 
$10262EAD8 accept 
$10262E490 perform 