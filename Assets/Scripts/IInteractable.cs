using UnityEngine;
using System.Collections;

public interface IInteractable
{
    void SetHighlighted(bool isHighlighted);

    void ReceiveInteraction(Interaction interaction);

    bool CanInteract(Interaction interaction);
}