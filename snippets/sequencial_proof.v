(* DEBUGGING AN LTAC AND PRESENT IT SEQUENCIALLY IN PROOF GOAL WINDOW
Common way to print debugging information could be using `ltac::idtac`
ltac is supposed to do an action, and we wrap up the action with a `constr` into a term
With `constr` we can see the result of the computation in ltac
However, `constr` stops `idtac` from printing anything
To fix this, we design another ltac not to do an action, but to return a `constr`
Now the ltac has been nicely debugged and presented sequentially in the proof goal
*)

Module M.
  Inductive t :=
  | Pure {A : Set} (x : A) : t A
  | Other {A : Set} : t A
  .

  Axiom run : forall {A : Set}, t A -> A.
End M.

(* Original attempt to debug a small ltac *)
Ltac tac_1 e :=
  lazymatch type of e with
  | M.t _ => 
    let _ := idtac "case 1" in
    exact e
  | _ => 
    let _ := idtac "case 2" in
    exact (M.Pure e)
  end. 

(* The correct way to debug ltac while showing information *)
Ltac tac_1_trace e :=
  lazymatch type of e with
  | M.t _ => constr:(("case1", e))
  | _     => constr:(("case2", M.Pure e))
  end.

Definition test_expr := M.run (M.Pure (1 + 1)).

Definition test_compute_expr : True.
Proof.
  pose test_expr as t1. unfold test in t1.
  (* Correct way to apply computations on terms during proof *)
  let x := constr:(ltac:(tac_1 t1)) in pose x as t2. (* Disadvantage: doesn't print idtac *)
  let x := tac_1_trace t2 in pose x as t2_trace. (* The correct way to trace debugging information *)
Admitted.