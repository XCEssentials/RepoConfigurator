public
extension Optional
{
    func require(
        file: StaticString = #file,
        line: UInt = #line
        ) -> Wrapped
    {
        if
            let result = self
        {
            return result
        }
        else
        {
            fatalError(
                "Required value is not set",
                file: file,
                line: line
            )
        }
    }
}
