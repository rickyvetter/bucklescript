(* Copyright (C) 2015-2016 Bloomberg Finance L.P.
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






(** An pattern match on {!caml_set_oo_id args}
    Note that in the trunk, it is immutable by default now 
 *)
module E = Js_exp_make 


(* Sync up with [caml_set_oo_id] 
   Note if we inline {!Caml_exceptions.create}, 
   it seems can be useful for optimizations in theory, 
   in practice, it never happen, since the pattern match 
   never dig into it internally, so maybe {!Obj.set_tag} 
   is not necessary at all
*)
let make exception_str  : J.expression = 
  E.runtime_call Js_runtime_modules.exceptions Literals.create [exception_str]



(* TODO: only used in camlinternalOO, split it off as a separate module? *)
let caml_set_oo_id args = 
   E.runtime_call Js_runtime_modules.exceptions "caml_set_oo_id" args 
    
