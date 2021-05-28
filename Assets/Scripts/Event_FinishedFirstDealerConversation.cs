using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Event_FinishedFirstDealerConversation : MonoBehaviour, IEvent
{
    public Door dealerDoor;

    public void Fire() 
    {
        dealerDoor.isLocked = false;
        dealerDoor.shouldFireEvents = true;
    }
}
