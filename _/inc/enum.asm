;
; enum
;
; enum $0,1,\
;      T_INT,T_VOID,T_IF,T_WHILE,T_DO,T_ELSE,T_WRITE,T_READ,T_RETURN,T_ERR,T_EOT
; 
; enum $10,1,\
;      T_COMMA,T_MUL,T_LPAR,T_RPAR,T_LBRA,T_RBRA,T_PLUS,T_MINUS,T_SEMICOLON,T_LTE,T_GTE,T_NEQ,T_EQ
; 
; enum $20,1,\
;      T_LT,T_GT,T_NOT,T_ASSIGN,T_NUM,T_ID,T_DIV  
macro enum start,step,[items]
{
   common
        local count
        count=start
   forward
        items=count
        count=count+step
}
