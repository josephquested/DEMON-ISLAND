using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Item : MonoBehaviour
{
    // -- SYSTEM -- //

    protected PlayerController playerController;

    void Awake()
    {
        playerController = GameObject.FindWithTag("Player").GetComponent<PlayerController>();
        anim = GetComponent<Animator>();
    }

    // -- ITEM INFO -- //

    [Header("ITEM INFO")]
    public Sprite itemIcon;

    // -- ACTION -- //

    [Header("ACTION")]
    public bool isReadyToFire = true;
    public float fireDuration;
    public float fireTimer;

    public virtual void StartFire()
    {
        anim.Play("Fire");
        // override //
    }

    public virtual void StopFire()
    {
        anim.Play("Idle");
        // override //
    }

    public void ResetFireTimer()
    {
        fireTimer = fireDuration;
    }

    // -- INTERACTION -- //

    [Header("INTERACTION")]
    public Interaction interaction;


    // -- ANIMATION -- //

    [Header("ANIMATION")]
    public bool animControlsFireDuration;

    Animator anim;

    public void FireAnimFinished()
    {
        // StopFire();
        // playerController.ItemFireAnimFinished();
    }
}