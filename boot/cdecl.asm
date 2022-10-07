
macro ccall proc,[arg]			; call CDECL procedure
 { common
    local size
    size = 0
   reverse
    pushd arg
    size = size+8
   common
    call proc
    add esp,size }

macro proc [params]			; define CDECL procedure
 { common
    local args,size,current
    match name arg, params
    \{ if used name
       name:
       virtual at rbp+8
       match =,args, arg \\{ defargs@proc args \\}
       match =all@args, all@args \{ defargs@proc arg \\}
       args = $ - (rbp+8)
       end virtual \}
    match =all@args, all@args
    \{ if used params
       params:
       args = 0
       all@args equ \}
    all@vars equ
    current = 0
    if args | size
     push rbp
     mov rbp,rsp
     if size
      sub esp,size
     end if
    end if
    macro locals
    \{ virtual at rbp-size+current
       macro label . \\{ deflocal@proc .,: \\}
       struc db val \\{ deflocal@proc .,db val \\}
       struc dw val \\{ deflocal@proc .,dw val \\}
       struc dp val \\{ deflocal@proc .,dp val \\}
       struc dd val \\{ deflocal@proc .,dd val \\}
       struc dt val \\{ deflocal@proc .,dt val \\}
       struc dq val \\{ deflocal@proc .,dq val \\} \}
    macro endl
    \{ purge label
       restruc db,dw,dp,dd,dt,dq
       restruc byte,word,dword,pword,tword,qword
       current = $-(rbp-size)
       end virtual \}
    macro local [var]
    \{ \common locals
       \forward match varname:vartype,var \\{ varname vartype \\}
       \common endl \}
    macro ret
    \{ if args | size
	leave
       end if
       retn \}
    macro finish@proc \{ size = (((current-1) shr 2)+1) shl 2
			 end if \} }

macro defargs@proc [arg]
 { common
    if ~ arg eq
   forward
     local ..arg,current@arg
     match argname:type, arg
      \{ current@arg equ argname
	 label ..arg type
	 argname equ ..arg
	 if qword eq type | pword eq type
	   dq
	 else
	   dd ?
	 end if \}
     match =current@arg,current@arg
      \{ current@arg equ arg
	 arg equ ..arg
	 ..arg dd ? \}
   common
     all@args equ current@arg
   forward
     restore current@arg
   common
    end if }

macro deflocal@proc name,def
 { match vars, all@vars \{ all@vars equ all@vars,name \}
   match ,all@vars \{ all@vars equ name \}
   local ..var
   name equ ..var
   ..var def }

macro endp
 { purge ret,locals,endl,local
   finish@proc
   purge finish@proc
   match all,all@args \{ restore all \}
   restore all@args
   match all,all@vars \{ restore all \} }
