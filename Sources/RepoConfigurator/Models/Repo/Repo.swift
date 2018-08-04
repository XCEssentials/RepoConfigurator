public
struct Repo
{
    public
    typealias Company = (
        name: String,
        identifier: String,
        prefix: String,
        developmentTeamId: String
    )

    public
    typealias Product = (
        name: String,
        summary: String
    )

    //---

    public
    let swiftVersion: VersionString

    public
    let tstSuffix: String

    public
    let company: Company

    public
    let product: Product
}
