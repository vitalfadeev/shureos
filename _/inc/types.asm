;
; types
;
macro m8   name { name db   0 }
macro m16  name { name dw   0 }
macro m32  name { name dd   0 }
macro m64  name { name dq   0 }
macro m128 name { name ddq  0 }
macro m256 name { name dqq  0 }
macro m512 name { name ddqq 0 }

ptr8   equ byte 
ptr16  equ word 
ptr32  equ dword
ptr64  equ qword
ptr128 equ dqword
ptr256 equ qqword
ptr512 equ dqqword
