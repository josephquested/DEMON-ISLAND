using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class InteractableItem : MonoBehaviour, IInteractable
{

    public GameObject highlightObj;

    public string interactableText;

    UIController uic;

    void Awake ()
    {
        uic = GameObject.FindWithTag("UIController").GetComponent<UIController>();
    }

    public void SetHighlighted(bool isHighlighted)
    {
        highlightObj.SetActive(isHighlighted);
        uic.EnableInteractionText(isHighlighted, interactableText);
    }

    public void ReceiveInteraction(Interaction interaction)
    {

    }

    public bool CanInteract(Interaction interaction)
    {
        return false;
    }

    public string GetInteractableText()
    {
        return interactableText;
    }
}
