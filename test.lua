-- TEST SIMPLE - Si ves esta notificación, el executor funciona
game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "TEST",
    Text = "Executor funciona!",
    Duration = 10,
})

print("TEST: Executor funcionando correctamente")
