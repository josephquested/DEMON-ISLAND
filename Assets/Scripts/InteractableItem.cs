using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class InteractableItem : MonoBehaviour, IInteractable
{

    public GameObject highlightObj;

    public string interactableText;

    public Item item;

    UIController uic;

    PlayerController pc;

    void Awake ()
    {
        uic = GameObject.FindWithTag("UIController").GetComponent<UIController>();
        pc = GameObject.FindWithTag("Player").GetComponent<PlayerController>();
    }

    public void SetHighlighted(bool isHighlighted)
    {
        highlightObj.SetActive(isHighlighted);
        uic.EnableInteractionText(isHighlighted, interactableText);
    }

    public void ReceiveInteraction(Interaction interaction)
    {
        pc.GetItem(item);
    }

    public bool CanInteract(Interaction interaction)
    {
        return true;
    }

    public string GetInteractableText()
    {
        return interactableText;
    }
}
