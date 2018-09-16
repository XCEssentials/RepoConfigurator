import ShellOut  // marathon:https://github.com/JohnSundell/ShellOut.git
import Files // marathon:https://github.com/JohnSundell/Files.git

//---

do
{
    let setupFolder = try Folder
        .current
        .subfolder(named: ".setup")

    let output = try shellOut(
        to: "ice run",
        at: setupFolder.path
    )

    print(output)
}
catch
{
    print("❌ Failed to run 'Setup' script! \(error)")
}
