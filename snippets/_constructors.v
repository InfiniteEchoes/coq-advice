(* TODO: doesn't compile without dependency *)

Inductive primitives :=
| TEq0 (_ : Z)
| TOther
.

(* NOTE: ideas:
- necessary universal parameters should be collected at lhs of colon so 
  that they're accessible to constructors of inductive types
- types at rhs of the colon are supposed to be tags for the type being 
  presented altogether as a proposition
- rhs tags can depend only from lhs parameters
- parameters under the constructors are supposed to be as few and necessary
  as possible
- reason for above: if we put same parameters under constructors plus rhs
  we will have a problem unifying these copies
  for rhs and constructors sharing the same copy we should put what they 
  share in the left
- when designing the propositions, take it carefully for the tags to hold
  necessary informations without being computed, for example an extra 
  uncalculated builder. this helps the prover to set up less necessary
  equations to reason between unlinked variables
- TODO: write more clearly what are necessary informations and when will 
  we need them
- TODO: figure out more clearly when will Coq prove false
*)
Reserved Notation "{{{ e , b | L }}}".
Inductive design_proposition (b : Builder.t) : 
  primitives -> Builder.t -> Prop :=
| PEq (x : Z) : 
  {{{ TEq0 x, b | 
    if (compute_assert x b) 
    then add_assert 1 b
    else add_assert 0 b }}}
where "{{{ e , b | L }}}" := (design_proposition b e L).

Theorem eqx0_to_eq0 : forall (b : Builder.t) (x : Z),
  compute_context b = 1 ->
  x = 0 ->
  {{{ TEq0 x, b | 
  add_assert 1 b
  }}}.
Proof.
  intros b x valid eqx.
  pose (PEq b x) as PEq0.
  unfold compute_assert in PEq0.
  rewrite -> valid in PEq0.
  rewrite -> eqx in PEq0.
  simpl in PEq0.
  rewrite <- eqx in PEq0.
  exact PEq0.
Qed.

(* NOTE: 
When designing this theorem, one previous attempt is stating the
proposition like this:
{{{ TEq0 0, b | add_assert 1 b }}}
and we can see that 0 is not dependent on x
the experience we get here is that we want to carry as much information(?)
as possible in the type, and know that x doesn't automatically change into
0 without an equation 
*)
Theorem eq0_to_eqx0 : forall (b : Builder.t) (x : Z),
  compute_context b = 1 ->
  {{{ TEq0 x, b | add_assert 1 b }}} ->
  x = 0.
Proof.
  intros b x valid e.
  inversion e.
  simpl in H.
  symmetry in valid.
  unfold compute_assert in H.
  rewrite <- valid in H.
  simpl in H.
  destruct (x =? 0) eqn:Eqx0 in H.
  - apply Z.eqb_eq in Eqx0. exact Eqx0.
  - inversion H.
Qed.