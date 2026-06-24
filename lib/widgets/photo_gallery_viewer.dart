import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class PhotoGalleryViewer extends StatefulWidget {
  final String title;
  final List<File> photos;
  final Function(ImageSource) onAddPhoto;
  final VoidCallback onUpdate;

  const PhotoGalleryViewer({
    Key? key,
    required this.title,
    required this.photos,
    required this.onAddPhoto,
    required this.onUpdate,
  }) : super(key: key);

  @override
  State<PhotoGalleryViewer> createState() => _PhotoGalleryViewerState();
}

class _PhotoGalleryViewerState extends State<PhotoGalleryViewer> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        padding: const EdgeInsets.all(16),
        width: double.maxFinite,
        height: 500,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(child: Text(widget.title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis)),
                IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(context)),
              ],
            ),
            const Divider(),
            Expanded(
              child: widget.photos.isEmpty
                  ? const Center(child: Text("Aucune photo", style: TextStyle(color: Colors.grey)))
                  : GridView.builder(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 8,
                        mainAxisSpacing: 8,
                      ),
                      itemCount: widget.photos.length,
                      itemBuilder: (context, index) {
                        return Stack(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.file(
                                widget.photos[index],
                                fit: BoxFit.cover,
                                width: double.infinity,
                                height: double.infinity,
                              ),
                            ),
                            Positioned(
                              top: 4,
                              right: 4,
                              child: GestureDetector(
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (c) => AlertDialog(
                                      title: const Text("Supprimer"),
                                      content: const Text("Voulez-vous supprimer cette photo ?"),
                                      actions: [
                                        TextButton(onPressed: () => Navigator.pop(c), child: const Text("Annuler")),
                                        TextButton(
                                          onPressed: () {
                                            setState(() {
                                              widget.photos.removeAt(index);
                                            });
                                            widget.onUpdate();
                                            Navigator.pop(c);
                                          },
                                          child: const Text("Supprimer", style: TextStyle(color: Colors.red)),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                                child: Container(
                                  decoration: const BoxDecoration(
                                    color: Colors.black54,
                                    shape: BoxShape.circle,
                                  ),
                                  padding: const EdgeInsets.all(4),
                                  child: const Icon(Icons.delete, color: Colors.white, size: 20),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  icon: const Icon(Icons.camera_alt),
                  label: const Text("Caméra"),
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFE1660B), foregroundColor: Colors.white),
                  onPressed: () async {
                    await widget.onAddPhoto(ImageSource.camera);
                    setState(() {});
                  },
                ),
                ElevatedButton.icon(
                  icon: const Icon(Icons.image),
                  label: const Text("Galerie"),
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF2A2E5D), foregroundColor: Colors.white),
                  onPressed: () async {
                    await widget.onAddPhoto(ImageSource.gallery);
                    setState(() {});
                  },
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
