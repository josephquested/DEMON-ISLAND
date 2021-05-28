using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class UIInventorySlot : MonoBehaviour
{
    public Image itemIcon;
    public Image frameImage;

    public void SetItemIcon(Sprite sprite)
    {
        itemIcon.sprite = sprite;
    }

    public void SetSelected(bool isSelected)
    {
        frameImage.color = isSelected ? Color.white : Color.black;
    }
}