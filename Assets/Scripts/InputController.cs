using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Rewired;

public class InputController : MonoBehaviour
{
    // -- SYSTEM -- //

    Player player; 
    public int playerId = 0;

    void Awake()
    {
        player = ReInput.players.GetPlayer(playerId);
    }

    void Update()
    {
        UpdateInput();
        UpdateMouse();
    }

    // -- INPUT -- //

    [Header("INPUT")]
    public bool cursorLocked;
    public bool controlsEnabled;
    public bool rawInput;
    public bool allowMouseMove;
    public float mouseSensitivity;
    public float mouseSmoothing;
    public float mouseSensitivityXMultiplier;
    public float mouseSensitivityYMultiplier;
    public Vector3 movementInput;
    public Vector2 lookInput;
    public float inventoryScrollInput;
    public bool runHeld;
    public bool fireDown;
    public bool interactDown;
    public bool aimDown;
    public bool aimHeld;
    public bool inventorySelectRight;
    public bool inventorySelectLeft;
    public Vector3 cameraEulerAngles;
    public Vector3 playerEulerAngles;
    Vector2 TargetLookAngles;
    Vector2 LookAngles;
    Vector2 LookAnglesDelta;
    Transform playerTrans;
    Transform cameraTrans;

    public bool toggleCrafting;

    void UpdateInput() 
    {
        runHeld = player.GetButton("Run");
        aimHeld = player.GetButton("Aim");
        aimDown = player.GetButtonDown("Aim");
        fireDown = player.GetButtonDown("Fire");
        interactDown = player.GetButtonDown("Interact");
        movementInput.x = player.GetAxis("Move Horizontal"); 
        movementInput.z = player.GetAxis("Move Vertical");
        lookInput.x = player.GetAxis("Look Horizontal");
        lookInput.y = player.GetAxis("Look Vertical");
        inventoryScrollInput = player.GetAxisRaw("Inventory Scroll");
        inventorySelectLeft = player.GetButtonDown("Inventory Select Left");
        inventorySelectRight = player.GetButtonDown("Inventory Select Right");
        toggleCrafting = player.GetButtonDown("Toggle Crafting");
    }

    void UpdateMouse()
    {
        Cursor.visible = !cursorLocked;
        Cursor.lockState = cursorLocked ? CursorLockMode.Locked : CursorLockMode.None;

         if (allowMouseMove)
            {
                Vector2 rawDelta = new Vector2(GetCurrentAxis("Look Horizontal") * mouseSensitivityXMultiplier, GetCurrentAxis("Look Vertical") * mouseSensitivityYMultiplier) * mouseSensitivity; // Raw delta of the mouse.
                TargetLookAngles += rawDelta; // Apply raw delta to target look angles.
                TargetLookAngles = new Vector2(TargetLookAngles.x, Mathf.Clamp(TargetLookAngles.y, -90f, 90f)); // Clamp target look angles Y values between -90...90 to avoid looking too much up or down.

                Vector2 newLookAngles = Vector2.Lerp(TargetLookAngles, Vector2.Lerp(LookAngles, TargetLookAngles, Time.deltaTime), mouseSmoothing); // Set the new look angles also taking into account mouse smoothing by doing a lerp between the target look angles and a very smoothly lerped target look angles.

                LookAnglesDelta = newLookAngles - LookAngles; // Calculate the delta, taking into account the mouse smoothing.
                LookAngles += LookAnglesDelta; // Apply the delta to our look angles.
            }

            cameraEulerAngles = new Vector3(-LookAngles.y, 0, 0); // Set the camera euler X axis to the negative of the Y look angles.
            playerEulerAngles = new Vector3(0, LookAngles.x, 0); // Set the player euler Y axis to the X look angles.
    }

    float GetCurrentAxis(string axisName)
    {
        return rawInput ? GetAxisRaw(axisName) : GetAxis(axisName);
    }

     protected float GetAxis(string axisName)
    {
        return controlsEnabled ? player.GetAxis(axisName) : 0f;
    }
    protected float GetAxisRaw(string axisName)
    {
        return controlsEnabled ? player.GetAxisRaw(axisName) : 0f;
    }
}
