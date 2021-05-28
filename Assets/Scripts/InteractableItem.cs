using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class InteractableItem : MonoBehaviour, IInteractable
{
    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        
    }

    public GameObject highlightObj;

    public void SetHighlighted(bool isHighlighted)
    {
        highlightObj.SetActive(isHighlighted);
    }

    public void ReceiveInteraction(Interaction interaction)
    {

    }

    public bool CanInteract(Interaction interaction)
    {
        return false;
    }
}
