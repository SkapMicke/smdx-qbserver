local Translations = {
    menus = {
        header = 'Crafting Menu',
        pickupworkBench = 'Pick up Workbench',
        entercraftAmount = 'Enter Craft Amount:',
    },
    notifications = {
        pickupBench = 'You have picked up the workbench.',
        invalidAmount = 'Invalid Amount Entered',
        invalidInput = 'Invalid Input Entered',
        notenoughMaterials = "You don't have enough materials!",
        craftingCancelled = 'You cancelled the crafting',
        tablePlace = 'Your Crafting Table was placed',
        craftMessage = 'You have crafted a %s',
        xpGain = 'You have gained %d XP in %s',
    }
}

Lang = Lang or Locale:new({
    phrases = Translations,
    warnOnMissing = true
})
