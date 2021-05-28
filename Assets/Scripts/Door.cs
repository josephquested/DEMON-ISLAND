using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Door : MonoBehaviour, IInteractable
{
    // -- SYSTEM -- //

    Animator anim;
    AudioSource aud;

    void Awake()
    {
        anim = GetComponent<Animator>();
        aud = GetComponent<AudioSource>();
    }

    // -- INTERACTABLE -- //

    public void SetHighlighted(bool isHighlighted)
    {

    }

    public void ReceiveInteraction(Interaction interaction)
    {
        FireUse();
    }

    public bool CanInteract(Interaction interaction)
    {
        return interaction.type == InteractionType.Use;
    }

    // -- USE -- //

    [Header("USE")]
    public bool isLocked = false;
    public bool lockAfterOpening = false;
    public bool shouldFireEvents = false;
    public GameObject[] eventObjects;

    public void SystemUse()
    {
        anim.SetTrigger("Use");
        aud.Play();
    }

    void FireUse()
    {
        if (!isLocked)
        {
            // if this door triggers events, trigger them
            if (eventObjects.Length > 0 && shouldFireEvents)
            {
                for(int i = 0; i < eventObjects.Length; i++)
                    eventObjects[i].GetComponent<IEvent>().Fire();
            }

            // open the door and play sfx
            anim.SetTrigger("Use");
            aud.Play();

            // lock the door after opening / closing if appropriate
            if (lockAfterOpening)
                isLocked = true;
        }
    }
}
