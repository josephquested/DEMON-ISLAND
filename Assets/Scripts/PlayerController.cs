using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using MonsterLove.StateMachine;
using System.Runtime.InteropServices;

public enum PlayerState { Idle, Moving };

public class PlayerController : MonoBehaviour
{

    UIController uic;

    // -- SYSTEM -- //

    void Awake()
    {
        ic = GameObject.FindWithTag("InputController").GetComponent<InputController>();
        rb = GetComponent<Rigidbody>();
        anim = GetComponent<Animator>();
        uic = GameObject.FindWithTag("UIController").GetComponent<UIController>();
        fsm = StateMachine<PlayerState>.Initialize(this, PlayerState.Idle);
        footstepAudio = GetComponentInChildren<FootstepAudio>();
        cameraTrans = GetComponentInChildren<Camera>().transform;
    }

    void Start()
    {
        InitSlotUI();
        UpdateInventoryUI();
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
        UpdateNumberEquip();
        UpdateEquippedSlot();
        UpdateInteract();
        UpdateToggleCrafting();
        UpdateCrafting();
        UpdateInteractions();


         if (Input.GetKeyDown(KeyCode.Space))
        {
            itemQuantities[0] = 99;
            itemQuantities[1] = 99;
            itemQuantities[2] = 99;
            itemQuantities[3] = 99;
            itemQuantities[4] = 99;
            itemQuantities[5] = 99;
            itemQuantities[6] = 99;
            itemQuantities[7] = 99;
            itemQuantities[8] = 99;
            itemQuantities[9] = 99;
            UpdateInventoryUI();
            uic.ShowInventory();
        }
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
    public List<Item> items = new List<Item>(); 

    public List<int> itemQuantities = new List<int>();   

    void UpdateNumberEquip()
    {
        if (!craftingMenuOpen)
        {
            if (Input.GetKeyDown(KeyCode.Alpha1))
            {
                ChangeEquippedItem(0);
                uic.ShowInventory();
            }
            else if (Input.GetKeyDown(KeyCode.Alpha2))
            {
                ChangeEquippedItem(1);
                uic.ShowInventory();
            }
            else if (Input.GetKeyDown(KeyCode.Alpha3))
            {
                ChangeEquippedItem(2);
                uic.ShowInventory();
            }
            else if (Input.GetKeyDown(KeyCode.Alpha4))
            {
                ChangeEquippedItem(3);
                uic.ShowInventory();
            }
            else if (Input.GetKeyDown(KeyCode.Alpha5))
               {
                ChangeEquippedItem(4);
                uic.ShowInventory();
            }
            else if (Input.GetKeyDown(KeyCode.Alpha6))
            {
                ChangeEquippedItem(5);
                uic.ShowInventory();
            }
            else if (Input.GetKeyDown(KeyCode.Alpha7))
            {
                ChangeEquippedItem(6);
                uic.ShowInventory();
            }
            else if (Input.GetKeyDown(KeyCode.Alpha8))
            {
                ChangeEquippedItem(7);
                uic.ShowInventory();
            }
            else if (Input.GetKeyDown(KeyCode.Alpha9))
            {
                ChangeEquippedItem(8);
                uic.ShowInventory();
            }
            else if (Input.GetKeyDown(KeyCode.Alpha0))
            {
                ChangeEquippedItem(9);
                uic.ShowInventory();
            }
        }
    }

    public void GetItem (Item item, GameObject interactableObj) 
    {
        int itemIndex = item.itemIndex;
        itemQuantities[itemIndex]++;
        Destroy(interactableObj);
        ClearInteractable();
        UpdateInventoryUI();
        uic.ShowInventory();
        ChangeEquippedItem(equippedIndex);
    }

    void UpdateInventoryUI()
    {
        uic.UpdateInventorySlots(itemQuantities);
    }

    public int equippedIndex = 0;

    public void UpdateEquippedSlot()
    {   
        if (ic.inventorySelectLeft || ic.inventorySelectRight)
            uic.ShowInventory();


        int _equippedIndex = equippedIndex;

        if (ic.inventorySelectLeft)
            _equippedIndex--;
        else if (ic.inventorySelectRight)
            _equippedIndex++;
        
        if (_equippedIndex < 0)
            _equippedIndex = 9;
        else if (_equippedIndex > 9)
            _equippedIndex = 0;
        
        if (_equippedIndex != equippedIndex)
        {
            ChangeEquippedItem(_equippedIndex);
        }
    }

    void InitSlotUI()
    {
        uic.SetSlotSelected(0);
    }

    void ChangeEquippedItem (int _equippedIndex)
    {
        itemObjs[equippedIndex].SetActive(false);
        equippedIndex = _equippedIndex;
        uic.SetSlotSelected(equippedIndex);

        if (itemQuantities[equippedIndex] > 0)
            itemObjs[equippedIndex].SetActive(true);

    }

    public GameObject[] itemObjs;

    // this thing above should actually be a classs, "inventoryitem" and you should be able to add an item to it. so like, the inventory is an array of inventroyitems, and you can increase or decrease their amount // 

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

    // -- CRAFTING -- //

    bool craftingMenuOpen = false;

    void UpdateToggleCrafting ()
    {
        if (ic.toggleCrafting)
        {
            if (craftingMenuOpen)
            {
                uic.HideCraftingMenu(true);
                craftingMenuOpen = false;
                uic.HideInventory();
            }
            else
            {
                uic.HideCraftingMenu(false);
                craftingMenuOpen = true;
                StartCoroutine(KeepInventoryOpenRoutine());
            }
        }
    }

    void UpdateCrafting()
    {
        if (craftingMenuOpen)
        {
            if (Input.GetKeyDown(KeyCode.Alpha1))
                TryCraftFire();


            if (Input.GetKeyDown(KeyCode.Alpha3))
                TryCraftRod();
            
        }
    }

    IEnumerator KeepInventoryOpenRoutine()
    {
        while(craftingMenuOpen)
        {
            uic.ShowInventory();
            yield return null;
        }
    }

    public Transform fireSpawnTrans;

    public GameObject firePrefab;

    void TryCraftFire()
    {
        if (itemQuantities[0] < 1 || itemQuantities[8] < 3)
        {
            uic.DisplayCraftingMessage("NOT ENOUGH");
        }

        else
        {
            RaycastHit hit;

            if (Physics.Raycast(fireSpawnTrans.position, -Vector3.up, out hit)) {
                Instantiate(firePrefab, hit.point, transform.rotation);
                itemQuantities[8] -= 3;
                uic.DisplayCraftingMessage("MADE FIRE");
            }
        }
    }

     void TryCraftRod()
    {
        if (itemQuantities[9] < 1 || itemQuantities[8] < 1)
        {
            uic.DisplayCraftingMessage("NOT ENOUGH");
        }

        else
        {
                itemQuantities[9] -= 1;
                itemQuantities[8] -= 1;
                itemQuantities[2] += 1;
                UpdateInventoryUI();
                uic.DisplayCraftingMessage("MADE ROD");
                uic.ShowInventory();
        }
    }

    // INTERACTIONS // 

    void UpdateInteractions()
    {
        // rod //
        if (equippedIndex == 2)
        {
            if (ic.fireDown)
            {
                print("can fish!");
            }
        }
    }
}