import os, json
from evaluate import load
from transformers.models.whisper.english_normalizer import BasicTextNormalizer

# Normaliza los textos
def normalize(preds, txts):
    normalizer = BasicTextNormalizer()
    # Para calcular el WER normalizado
    pred_str_norm = [normalizer(pred) for pred in preds]
    label_str_norm = [normalizer(label) for label in txts]
    # Filtrar los ejemplos que no se hayan normalizado correctamente
    pred_str_norm = [
        pred_str_norm[i] for i in range(len(pred_str_norm)) if len(label_str_norm[i]) > 0
    ]
    label_str_norm = [
        label_str_norm[i] for i in range(len(label_str_norm)) if len(label_str_norm[i]) > 0
    ]
    
    return pred_str_norm, label_str_norm

# Muestra el valor de WER a partir del modelo y una lista de archivos de manifiesto
# (utilizado para nuestro conjunto de datos)
def print_metric_medic(model, test_list):
    wer = load("wer")

    predicciones = []
    textos = []
    for tmanifest in test_list:
        with open(tmanifest, "r") as ft:
            for l in ft:
                sample = json.loads(l)
                predicciones.append(model.transcribe(paths2audio_files=[sample["audio_filepath"]], 
                                                     verbose=False)[0])
                textos.append(sample["text"])

    pred_str_norm, label_str_norm = normalize(predicciones, textos)

    score_wer_norm = wer.compute(predictions=pred_str_norm, references=label_str_norm)
    score_wer_orth = wer.compute(predictions=predicciones, references=textos)

    print("  WER_NORM: (medic)", score_wer_norm)
    print("  WER_ORTH: (medic)", score_wer_orth)

# Muestra el valor de WER a partir del modelo y un directorio
# (utilizado para el conjunto de datos LibriSpeech
def print_metric_libri(model, folder):
    wer = load("wer")

    predicciones = []
    textos = []
    
    for ruta, carpetas, archivos in os.walk(folder):
        carpetas[:] = [d for d in carpetas if not d[0] == '.']
        for archivo in archivos:
            if os.path.isfile(os.path.join(ruta, archivo)) and archivo.endswith('.txt'):
                with open(os.path.join(ruta, archivo), 'r') as ft:
                    for l in ft:
                        sample = l.split(" ", 1)
                        predicciones.append(model.transcribe(
                            paths2audio_files=[os.path.join(ruta, sample[0]+'.flac.wav')], 
                            verbose=False)[0])
                        textos.append(sample[1].lower())

    pred_str_norm, label_str_norm = normalize(predicciones, textos)

    score_wer_norm = wer.compute(predictions=pred_str_norm, references=label_str_norm)
    score_wer_orth = wer.compute(predictions=predicciones, references=textos)

    print("  WER_NORM (libri):", score_wer_norm)
    print("  WER_ORTH (libri):", score_wer_orth)

# Limpia el texto
def prepare_text(text):
    for noword in ['"', ',', ' - ', '...']:
        text = text.replace(noword, '')
    text = text.replace('’', "'")
    text = text.strip()
    if text[-1] not in [".", "?", "!"]:
        text = text + "."
    
    return text