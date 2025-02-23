import 'package:dokusend/services/document/document_info.dart';
import 'package:dokusend/services/document/document_service.dart';
import 'package:dokusend/utils/logger.dart';
import 'package:flutter/material.dart';
import 'package:dokusend/views/document_list_item.dart';

class DocumentList extends StatefulWidget {
  const DocumentList({super.key});

  @override
  State<DocumentList> createState() => DocumentListState();
}

class DocumentListState extends State<DocumentList> {
  final DocumentService _documentService = DocumentService();
  final List<DocumentInfo> _documents = [];
  final ScrollController _scrollController = ScrollController();
  bool _isLoading = false;
  bool _hasMore = true;
  static const int _pageSize = 20;

  @override
  void initState() {
    super.initState();
    _loadMoreDocuments();
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
      _loadMoreDocuments();
    }
  }

  Future<void> _loadMoreDocuments() async {
    if (_isLoading || !_hasMore) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final newDocuments = await _documentService.getDocumentInfos(
        offset: _documents.length,
        limit: _pageSize,
      );

      if (newDocuments.isEmpty) {
        logger.d('No more documents to load.');
      }

      setState(() {
        _documents.addAll(newDocuments);
        _isLoading = false;
        _hasMore = newDocuments.length == _pageSize;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> refreshDocuments() async {
    setState(() {
      _documents.clear();
      _hasMore = true;
    });
    await _loadMoreDocuments();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: refreshDocuments,
      child: _documents.isEmpty && _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _documents.isEmpty
              ? const Center(child: Text('No documents found.'))
              : ListView.builder(
                  controller: _scrollController,
                  itemCount: _documents.length + (_hasMore ? 1 : 0),
                  padding: EdgeInsets.zero,
                  itemBuilder: (context, index) {
                    if (index == _documents.length) {
                      return const Center(
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: CircularProgressIndicator(),
                        ),
                      );
                    }

                    final document = _documents[index];
                    return DocumentListItem(
                      documentInfo: document,
                      onTap: () {
                        // TODO: Handle document selection
                      },
                    );
                  },
                ),
    );
  }
}
