using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class UIInventorySlot : MonoBehaviour
{
    public Image itemIcon;
    public Image frameImage;

    public Text quantityText;

    public void SetItemIcon(Sprite sprite)
    {
        itemIcon.sprite = sprite;
    }

    public void SetSelected(bool isSelected)
    {
        frameImage.color = isSelected ? Color.white : Color.black;
    }

    public void SetIconTransparent(bool state)
    {
        if (state == true)
        {
            var tempColor = itemIcon.color;
            tempColor.a = 0.2f;
            itemIcon.color = tempColor;

            tempColor = quantityText.color;
            tempColor.a = 0.2f;
            quantityText.color = tempColor;
        }

        else 
        {
            var tempColor = itemIcon.color;
            tempColor.a = 1f;
            itemIcon.color = tempColor;

            tempColor = quantityText.color;
            tempColor.a = 1f;
            quantityText.color = tempColor;
        }
    }
}