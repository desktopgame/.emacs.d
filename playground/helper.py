def dot(v1: list[int | float], v2: list[int | float]) -> int | float:
    sum = 0
    for i in range(0, len(v1)):
        sum += v1[i] * v2[i]

    return sum


def dispmat(matrix):
    rows: int = len(matrix)
    cols: int = len(matrix[0])
    s = "$\\begin{matrix}"
    for i in range(0, rows):
        for j in range(0, cols):
            w: float = matrix[i][j]
            s += str(w)

            if j == 0:
                s += " & "
            else:
                s += " \\\\ "
    s += "\\end{matrix}$"
    return s
