input_file = "lexid.txt"
output_file = "temp.csv"

with open(input_file, "r") as input_file, open(output_file, "w") as output_file:
    found_start = False
    for line in input_file:
        line = line.strip()

        if line == "--start--":
            found_start = True
            continue
        if not found_start:
            continue
        
        if not line or line.startswith("#"):
            continue

        if line == "--stop--":
            break

        parts = line.split()

        if len(parts) >= 6:
            lexeme = parts[0].split("-")[0]
            category = parts[0].split("-")[1]
            declension = parts[2]
            variation = parts[4]
            kind = parts[6]
            additional_info = parts[7]

            tsv_line = f"{lexeme},{category},{declension},{variation},{kind},{additional_info}"

            output_file.write(tsv_line + "\n")

print("Conversion complete. Data saved to temp.csv.")
