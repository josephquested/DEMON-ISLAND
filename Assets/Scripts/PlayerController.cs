using UnityEngine;
using System.Collections;
using MonsterLove.StateMachine;
using System.Runtime.InteropServices;

public enum PlayerState { Idle, Moving };

public class PlayerController : MonoBehaviour
{

    // -- SYSTEM -- //

    void Awake()
    {
        ic = GameObject.FindWithTag("InputController").GetComponent<InputController>();
        rb = GetComponent<Rigidbody>();
        anim = GetComponent<Animator>();
        fsm = StateMachine<PlayerState>.Initialize(this, PlayerState.Idle);
        footstepAudio = GetComponentInChildren<FootstepAudio>();
        cameraTrans = GetComponentInChildren<Camera>().transform;
    }

    void FixedUpdate()
    {
        UpdateInput();
        UpdateCameraLook();
        UpdateInteractionRay();
        UpdateAnim();
    }

    void Update()
    {
        UpdateInteract();
    }

    // -- INPUT -- //

    InputController ic;
    Transform cameraTrans;

    void UpdateInput()
    {
        isRunning = ic.runHeld;
    }

    void UpdateCameraLook()
    {
        cameraTrans.localEulerAngles = ic.cameraEulerAngles;
        transform.localEulerAngles = ic.playerEulerAngles;
    }

    // -- STATE MACHINE  -- //

    StateMachine<PlayerState> fsm;

    // IDLE //

    void Idle_Update()
    {
        if (ic.movementInput != Vector3.zero)
            fsm.ChangeState(PlayerState.Moving);
    }

    // MOVING //

    bool isMoving;
    bool isRunning;

    void Moving_Enter()
    {
        isMoving = true;
    }

    void Moving_Update()
    {

    }

    void Moving_FixedUpdate()
    {
        rb.AddRelativeForce(GetMovementForce());

        if (ic.movementInput == Vector3.zero)
            fsm.ChangeState(PlayerState.Idle);
    }

    void Moving_Exit()
    {
        isMoving = false;
    }

    // -- MOVEMENT -- //

    Rigidbody rb;

    [Header("MOVEMENT")]
    public float movementSpeed;
    public float runSpeed;

    Vector3 GetMovementForce()
    {
        return ic.movementInput * GetMovementSpeed();
    }

    float GetMovementSpeed()
    {
        return isRunning ? movementSpeed + runSpeed : movementSpeed;
    }

    // -- INTERACTION -- //

    [Header("INTERACTION")]
    public float interactionDistance;
    public IInteractable interactable;
    public Interaction useInteraction;

    void UpdateInteract()
    {
        if (ic.interactDown && interactable != null)
        {
            if (interactable.CanInteract(useInteraction))
                interactable.ReceiveInteraction(useInteraction);
        }
    }

    void UpdateInteractionRay()
    {
        Ray ray = GetComponentInChildren<Camera>().ViewportPointToRay(new Vector3(0.5F, 0.5F, 0));
        RaycastHit hit;
        {
            if (Physics.Raycast(ray, out hit, interactionDistance))
            {
                if (hit.transform.GetComponent<IInteractable>() != null)
                {
                    IInteractable _interactable = hit.transform.GetComponent<IInteractable>();

                    if (interactable != _interactable)
                    {
                        if (interactable != null)
                            ClearInteractable();

                        interactable = _interactable;
                        interactable.SetHighlighted(true);
                    }
                }
                else
                {
                    if (interactable != null)
                        ClearInteractable();
                }
            }
            else if (interactable != null)
            {
                ClearInteractable();
            }
        }
    }

    void ClearInteractable()
    {
        interactable.SetHighlighted(false);
        interactable = null;
    }

    // -- INVENTORY -- //

    [Header("INVENTORY")]

    // -- ANIMATION -- //

    Animator anim;

    void UpdateAnim()
    {
        anim.SetBool("isMoving", isMoving);
        anim.SetBool("isRunning", isRunning);
    }

    // -- AUDIO -- // 

    FootstepAudio footstepAudio;

    public void PlayFootstepAudio()
    {
        footstepAudio.PlayFootstep(isRunning);
    }
}