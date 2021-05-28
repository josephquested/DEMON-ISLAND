using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class UIController : MonoBehaviour
{
    // -- UI CONTROL -- //

    public UIInventorySlot[] inventorySlots;

    public GameObject interactionParent;
    public Text interactionText;

    public Sprite blankSprite;

    public void EnableInteractionText(bool state, string _interactionText) 
    {
        interactionParent.SetActive(state);
        interactionText.text = _interactionText;
    }

    public void UpdateSelectedSlot(int slotIndex)
    {
        int i = 0;

        foreach(UIInventorySlot slot in inventorySlots)
        {
            bool isSelected = i == slotIndex;
            slot.SetSelected(isSelected);            
            i++;
        }
    }

    public void UpdateInventorySlots(Item[] items)
    {
        int i = 0;

        foreach(UIInventorySlot slot in inventorySlots)
        {
            if (items[i] != null)
                slot.SetItemIcon(items[i].itemIcon);
            else
                slot.SetItemIcon(blankSprite);
            i++;
        }
    }
}