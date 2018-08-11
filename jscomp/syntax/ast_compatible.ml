(* Copyright (C) 2018 Authors of BuckleScript
 * 
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Lesser General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * In addition to the permissions granted to you by the LGPL, you may combine
 * or link a "work that uses the Library" with a publicly distributed version
 * of this file to produce a combined library or application, then distribute
 * that combined work under the terms of your choosing, with no requirement
 * to comply with the obligations normally placed on you by section 4 of the
 * LGPL version 3 (or the corresponding section of a later version of the LGPL
 * should you choose to use a later version).
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Lesser General Public License for more details.
 * 
 * You should have received a copy of the GNU Lesser General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA. *)

type loc = Location.t 
type attrs = Parsetree.attribute list 
open Parsetree
let default_loc = Location.none

#if OCAML_VERSION =~ ">4.03.0" then 
type arg_label = Asttypes.arg_label
let no_label : arg_label = Nolabel
let is_arg_label_simple (s : arg_label) = s = (Nolabel : arg_label)  
#else 
type arg_label = string
let no_label : arg_label = ""
let is_arg_label_simple s = (s : arg_label) = no_label  
#end

let arrow ?(loc=default_loc) ?(attrs = []) a b  =
  Ast_helper.Typ.arrow ~loc ~attrs no_label a b  

let apply_simple
 ?(loc = default_loc) 
 ?(attrs = [])
  fn args : expression = 
  { pexp_loc = loc; 
    pexp_attributes = attrs;
    pexp_desc = 
      Pexp_apply(
        fn, 
        (Ext_list.map (fun x -> no_label, x) args) ) }

let app1        
  ?(loc = default_loc)
  ?(attrs = [])
  fn arg1 : expression = 
  { pexp_loc = loc; 
    pexp_attributes = attrs;
    pexp_desc = 
      Pexp_apply(
        fn, 
        [no_label, arg1]
        ) }

let app2
  ?(loc = default_loc)
  ?(attrs = [])
  fn arg1 arg2 : expression = 
  { pexp_loc = loc; 
    pexp_attributes = attrs;
    pexp_desc = 
      Pexp_apply(
        fn, 
        [
          no_label, arg1;
          no_label, arg2 ]
        ) }

let app3
  ?(loc = default_loc)
  ?(attrs = [])
  fn arg1 arg2 arg3 : expression = 
  { pexp_loc = loc; 
    pexp_attributes = attrs;
    pexp_desc = 
      Pexp_apply(
        fn, 
        [
          no_label, arg1;
          no_label, arg2;
          no_label, arg3
        ]
        ) }

let fun_         
  ?(loc = default_loc) 
  ?(attrs = [])
  pat
  exp = 
  {
    pexp_loc = loc; 
    pexp_attributes = attrs;
    pexp_desc = Pexp_fun(no_label,None, pat, exp)
  }


#if OCAML_VERSION =~ ">4.03.0" then 

let const_exp_string 
  ?(loc = default_loc)
  ?(attrs = [])
  ?delimiter
  (s : string) : expression = 
  {
    pexp_loc = loc; 
    pexp_attributes = attrs;
    pexp_desc = Pexp_constant(Pconst_string(s,delimiter))
  }


let const_exp_int 
  ?(loc = default_loc)
  ?(attrs = [])
  (s : int) : expression = 
  {
    pexp_loc = loc; 
    pexp_attributes = attrs;
    pexp_desc = Pexp_constant(Pconst_integer (string_of_int s, None))
  }


let apply_labels
 ?(loc = default_loc) 
 ?(attrs = [])
  fn (args : (string * expression) list) : expression = 
  { pexp_loc = loc; 
    pexp_attributes = attrs;
    pexp_desc = 
      Pexp_apply(
        fn, 
        Ext_list.map (fun (l,a) -> Asttypes.Labelled l, a)  args ) }

#else 

let const_exp_string 
  ?(loc = default_loc)
  ?(attrs = [])
  ?delimiter
  (s : string) : expression = 
  {
    pexp_loc = loc; 
    pexp_attributes = attrs;
    pexp_desc = Pexp_constant(Const_string(s,delimiter))
  }


let const_exp_int 
  ?(loc = default_loc)
  ?(attrs = [])
  (s : int) : expression = 
  {
    pexp_loc = loc; 
    pexp_attributes = attrs;
    pexp_desc = Pexp_constant(Const_int s)
  }




let apply_labels
 ?(loc = default_loc) 
 ?(attrs = [])
  fn args : expression = 
  { pexp_loc = loc; 
    pexp_attributes = attrs;
    pexp_desc = 
      Pexp_apply(
        fn, 
        args ) }


#end 


let const_exp_int_list_as_array xs = 
  Ast_helper.Exp.array 
  (Ext_list.map (fun x -> const_exp_int x ) xs)  

let const_exp_string_list_as_array xs =   
  Ast_helper.Exp.array 
  (Ext_list.map (fun x -> const_exp_string x ) xs)  
