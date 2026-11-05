def dot(v1: list[int | float], v2: list[int | float]) -> int | float:
    sum = 0
    for i in range(0, len(v1)):
        sum += v1[i] * v2[i]

    return sum


def matvec(matrix, vec: list[int | float]) -> list[int | float]:
    v: list[int | float] = []
    for i in range(0, len(matrix)):
        v.append(dot(matrix[i], vec))
    return v


def pprint(s: str):
    # print(f"${s}$")
    print(r"\[")
    print(s)
    print(r"\]")


def dispfloat(f: float) -> str:
    return f"{f:.4f}"


def dispvec(vec: list[int | float]) -> str:
    # \begin{pmatrix} -0.025 \\ -0.025 \\ 0.075 \\ -0.025 \end{pmatrix}
    s = "\\begin{pmatrix}"
    for i in range(0, len(vec)):
        v: float = vec[i]
        s += dispfloat(v)

        if i < len(vec) - 1:
            s += " \\\\ "
    s += "\\end{pmatrix}"
    return s


def dispmat(matrix) -> str:
    rows: list[str] = []
    for row in matrix:
        rows.append(" & ".join(dispfloat(v) for v in row))

    return r"\begin{matrix}" + r" \\ ".join(rows) + r"\end{matrix}"


def dispmat(matrix, before=None) -> str:
    rows = []

    for i, row in enumerate(matrix):
        cols = []

        for j, value in enumerate(row):
            s = dispfloat(value)

            if before is not None:
                old = before[i][j]

                if dispfloat(value) != dispfloat(old):
                    if value > old:
                        s = rf"\color{{blue}}{{{s}}}"
                    elif value < old:
                        s = rf"\color{{red}}{{{s}}}"

            cols.append(s)

        rows.append(" & ".join(cols))

    return r"\begin{matrix}" + r" \\ ".join(rows) + r"\end{matrix}"
